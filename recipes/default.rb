#
# Cookbook Name:: flyway-cli
# Recipe:: default
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

include_recipe 'flyway-cli::_install'

node['flyway']['confs'].each do |key, conf|
  url = conf['jdbc_url']
  user = conf['jdbc_username']
  password = conf['jdbc_password']

  if conf['data_bag']
    data_bag_conf = conf['data_bag']
    # Grab the encrypted data bag
    data_bag = nil
    if data_bag_conf.attribute?('secret_file')
      data_bag = Chef::EncryptedDataBagItem.load(data_bag_conf['name'],
        data_bag_conf['item'], Chef::EncryptedDataBagItem.load_secret(data_bag_conf['secret_file']))
    else
      data_bag = Chef::EncryptedDataBagItem.load(data_bag_conf['name'],
        data_bag_conf['item'])
    end

    fail 'Error retrieving data bag' if data_bag.nil?

    user = data_bag[data_bag_conf.fetch('jdbc_username_key', 'jdbc_username')]
    password = data_bag[data_bag_conf.fetch('jdbc_password_key', 'jdbc_password')]
  end

  flyway_cli key do
    action :migrate
    db_url url
    db_user user
    db_password password
    migrations_url conf['migrations_url']
    migrations_strip_components conf['migrations_strip_components'] if conf['migrations_strip_components']
    options conf['options']
  end
end
