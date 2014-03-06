#
# Cookbook Name:: flyway-cli
# Recipe:: default
#
# Copyright (C) 2014 ClouDesire
#
# All rights reserved - Do Not Redistribute
#

if node[:flyway][:include_java_recipe] == true
  include_recipe "java"
end

flyway_url = node[:flyway][:base_url].gsub! 'VERSION', node[:flyway][:version]
installation_path = node[:flyway][:installation_path]

remote_file "#{Chef::Config[:file_cache_path]}/flyway-commandline-#{node[:flyway][:version]}.tar.gz" do
    source flyway_url
end

bash 'extract_flyway' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      rm -fr #{installation_path}
      mkdir -p #{installation_path}
      tar xzf flyway-commandline-#{node[:flyway][:version]}.tar.gz -C #{installation_path} --strip-components=1
    EOH
    not_if { node[:flyway][:version] == node[:flyway][:version_installed] }
end

postgresql_jdbc = node[:flyway][:jdbc_driver][:postgresql]
remote_file installation_path + '/jars/postgresql-' + postgresql_jdbc[:version] + '.jar' do
    source postgresql_jdbc[:url].gsub! 'VERSION', postgresql_jdbc[:version]
end

mysql_jdbc = node[:flyway][:jdbc_driver][:mysql]
remote_file installation_path + '/jars/mysql-connector-java-' + mysql_jdbc[:version] + '.jar' do
    source mysql_jdbc[:url].gsub! 'VERSION', mysql_jdbc[:version]
end

file installation_path + "/conf/flyway.properties" do
  owner "root"
  group "root"
  mode  "0755"
  action :create
  content <<-EOH
flyway.url=#{node[:flyway][:jdbc_url]}
flyway.user=#{node[:flyway][:jdbc_username]}
flyway.password=#{node[:flyway][:jdbc_password]}
  EOH
end

ruby_block 'set-installed-version' do
    block do
        node.set[:flyway][:version_installed] = node[:flyway][:version]
    end
end
