#
# Cookbook Name:: flyway-cli
# Recipe:: install
#
# Copyright (C) 2014 ClouDesire
#
# All rights reserved - Do Not Redistribute
#

installation_path = node['flyway']['installation_path']

base_url = Gem::Version.new(node['flyway']['version']) < Gem::Version.new('3.0') ? node['flyway']['old_base_url'] : node['flyway']['base_url']
flyway_url = base_url.gsub! 'VERSION', node['flyway']['version']

if platform_family?("windows") # Windows

  include_recipe 'windows'
  if node['flyway']['version'] != node['flyway']['version_installed']
    # Download and unzip flyway zip file
    flyway_url = flyway_url.gsub! 'tar.gz', 'zip'
    windows_zipfile installation_path do
      source flyway_url
      action :unzip
      overwrite true
    end

    # strip flyway-VERSION folder
    windows_batch 'unzip_and_move_ruby' do
      code <<-EOH
      xcopy #{installation_path}\\flyway-#{node['flyway']['version']} #{installation_path} /e /y
      rd /s /q #{installation_path}\\flyway-#{node['flyway']['version']}
      EOH
    end

  end

  # Download jtds driver
  sql_jdbc = node['flyway']['jdbc_driver']['jtds']
  remote_file installation_path + '/jars/jtds-' + sql_jdbc['version'] + '.jar' do
    source sql_jdbc['url'].gsub! 'VERSION', sql_jdbc['version']
    action :create_if_missing
  end

else # Linux
  remote_file "#{Chef::Config[:file_cache_path]}/flyway-commandline-#{node['flyway']['version']}.tar.gz" do
    source flyway_url
  end

  bash 'extract_flyway' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      set -e
      shopt -s extglob
      rm -rf #{installation_path}/!(sql)
      shopt -u extglob
      mkdir -p #{installation_path}
      tar xzf flyway-commandline-#{node['flyway']['version']}.tar.gz -C #{installation_path} --strip-components=1
    EOH
    not_if { node['flyway']['version'] == node['flyway']['version_installed'] }
  end

end

postgresql_jdbc = node['flyway']['jdbc_driver']['postgresql']
remote_file installation_path + '/jars/postgresql-' + postgresql_jdbc['version'] + '.jar' do
  source postgresql_jdbc['url'].gsub! 'VERSION', postgresql_jdbc['version']
  action :create_if_missing
end

mysql_jdbc = node['flyway']['jdbc_driver']['mysql']
remote_file installation_path + '/jars/mysql-connector-java-' + mysql_jdbc['version'] + '.jar' do
  source mysql_jdbc['url'].gsub! 'VERSION', mysql_jdbc['version']
  action :create_if_missing
end

ruby_block 'set-installed-version' do
  block do
    node.set['flyway']['version_installed'] = node['flyway']['version']
  end
end
