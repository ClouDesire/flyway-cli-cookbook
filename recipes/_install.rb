#
# Cookbook Name:: flyway-cli
# Recipe:: _install
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

flyway_cli 'default' do
  create_user node['flyway']['create_user']
  jdbc_driver node['flyway']['jdbc_driver'] if node['flyway']['jdbc_driver']
end
