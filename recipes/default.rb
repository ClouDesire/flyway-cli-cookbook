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

directory node[:flyway][:installation_path] do
  recursive true
end

node[:flyway][:confs].each do |key, confs|
  sql_dir = node[:flyway][:migrations_path] + "/#{key}"
  directory sql_dir do
    recursive true
    action :create
  end
end

include_recipe "flyway-cli::install"
