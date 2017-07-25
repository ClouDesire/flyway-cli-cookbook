#
# Cookbook Name:: flyway-cli
# Resource:: default
#
# Copyright 2014 ClouDesire
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

property :create_user, [true, false], default: node['flyway']['create_user']
property :flyway_user, String, default: node['flyway']['user']
property :flyway_group, String, default: node['flyway']['group']
property :install_java, [true, false], default: node['flyway']['include_java_recipe']
property :version, String, default: node['flyway']['version']
property :flyway_url, String
property :install_path, String, default: node['flyway']['installation_path']
property :jdbc_driver, String
property :migrations_path, String, default: node['flyway']['migrations_path']
property :migrations_url, String
property :migrations_strip_components, Integer, default: 0
property :db_url, String
property :db_user, String
property :db_password, String
property :options, Hash

default_action :install

action_class do
  def get_flyway_url
    flyway_url = new_resource.flyway_url
    if flyway_url.nil?
      flyway_url = Gem::Version.new(new_resource.version) < Gem::Version.new('3.0') ? node['flyway']['old_base_url'] : node['flyway']['base_url']
      flyway_url = flyway_url.gsub 'VERSION', node['flyway']['version']
      if platform_family?('windows')
        flyway_url = flyway_url.gsub 'tar.gz', 'zip'
      end
    end
    flyway_url
  end

  def install_migrations
    directory new_resource.migrations_path do
      owner new_resource.flyway_user
      group new_resource.flyway_group
      recursive true
    end

    ark new_resource.name do
      action :put
      path new_resource.migrations_path
      url new_resource.migrations_url
      owner new_resource.flyway_user
      strip_components new_resource.migrations_strip_components
    end
  end
end

action :install do
  if new_resource.install_java
    include_recipe 'java'
  end

  group new_resource.flyway_group do
    only_if { new_resource.create_user }
  end

  user new_resource.flyway_user do
    gid new_resource.flyway_group
    system true
    only_if { new_resource.create_user }
  end

  directory new_resource.install_path do
    owner new_resource.flyway_user
    group new_resource.flyway_group
    recursive true
  end

  ark ::File.basename(new_resource.install_path) do
    action :put
    path ::File.dirname(new_resource.install_path)
    url get_flyway_url
    owner new_resource.flyway_user
  end

  remote_file "#{new_resource.install_path}/drivers/#{::File.basename(new_resource.jdbc_driver)}" do
    owner new_resource.flyway_user
    group new_resource.flyway_group
    source new_resource.jdbc_driver
  end if new_resource.jdbc_driver
end

action :migrate do
  errors = []
  errors << 'A value for db_user has not been provided' if new_resource.db_user.nil?
  errors << 'A value for db_password has not been provided' if new_resource.db_password.nil?
  errors << 'A value for db_url has not been provided' if new_resource.db_url.nil?
  fail "Unable to run migration:\n#{errors.map{|e| "  * #{e}"}.join("\n")}" unless errors.empty?

  install_migrations if new_resource.migrations_url

  # Flyway doesn't care if platform is windows or linux
  migrations_path = "#{new_resource.migrations_path}/#{new_resource.name}".gsub(/\\/, '/')

  property_file = "#{new_resource.install_path}/conf/#{new_resource.name}.properties"
  template property_file do
    owner new_resource.flyway_user
    group new_resource.flyway_group
    cookbook 'flyway-cli'
    source 'flyway.properties.erb'
    mode '0640'
    sensitive
    variables(
      url: new_resource.db_url,
      user: new_resource.db_user,
      password: new_resource.db_password,
      migrations_path: migrations_path,
      java_home: node['java']['java_home'],
      options: new_resource.options
    )
  end

  flyway_command = new_resource.install_path + "/flyway migrate -configFile=#{property_file}"

  if platform?('windows')
    batch 'set_java_home_and_run_flyway' do
      code <<-EOH
        set JAVA_HOME=#{node['java']['java_home']}
        #{flyway_command}
      EOH
    end
  else
    execute 'run migrations' do
      command flyway_command
    end
  end
end
