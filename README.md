flyway-cli-cookbook
===================

[![Build Status](https://travis-ci.org/ClouDesire/flyway-cli-cookbook.svg?branch=master)](https://travis-ci.org/ClouDesire/flyway-cli-cookbook) [![Supermarket version](https://img.shields.io/cookbook/v/flyway-cli.svg)](https://supermarket.chef.io/cookbooks/flyway-cli)

This cookbook installs, configures, and runs the CLI version of the flyway tool.

# Supported Databases
The following JDBC drivers [are included](https://flywaydb.org/documentation/commandline/index.html) with the flyway command-line tool:

 * SQL Server (jTDS)
 * MySQL
 * MariaDB
 * PostgreSQL
 * Redshift
 * H2
 * Hsql
 * Derby
 * SQLite

Additional JDBC drivers can be passed in utilizing the following node attribute `node['flyway']['jdbc_driver']` with the default recipe, or can be passed into the custom resource (documented below).

# Requirements

### Platforms

 * Ubuntu
 * Windows

### Chef

 * Chef 12+

### Cookbooks

 * java
 * ark
 * compat_resource

An already configured database is required as well as database migrations.

# Usage

This cookbook provides two different methods that can be utilized for installing the flyway CLI and running the migrations.

Simply including the _install recipe on your node's run list will install the flyway command line tool, and including the default recipe will both install and run the migrations.

If the included recipes do not provide enough configurable functionality, then the custom resource can be utilized instead.

# Attributes

The following attributes are utilized by the recipes to configure installation and migration:

 * `['flyway']['version']`: The version of the flyway CLI to install (default='3.2.1')
 * `['flyway']['installation_path']`: The installation path for the CLI (default='/opt/flyway' for Linux distros, 'C:\flyway' for windows)
 * `['flyway']['migrations_path']`: The path where migrations are installed (default='/opt/flyway/sql' for Linux distros, 'C:\flyway\sql' for windows)
 * `['flyway']['include_java_recipe']`: Includes java as part of installation (default=true)
 * `['flyway']['jdbc_driver']`: The url for an optionally included JDBC driver, installed to a nested drivers directory
 * `['flyway']['create_user']`: Flag determining whether the flyway user and group should be created during installation (default='true')
 * `['flyway']['user']`: The user that will own and run the flyway process (default='flyway')
 * `['flyway']['group']`: The group the flyway user will be a part of (default='flyway')

The following attributes are utilized for executing the migrations:

 * `['flyway']['confs']["#{config_id}"]`: The identifier for the nested configuration. This identifier is used to namespace migrations into separate directories under `['flyway']['migrations_path']`, and identifies the flyway properties file used by the cli
 * `['flyway']['confs']["#{config_id}"]['jdbc_url']`: The url used for communicating with the database (required)
 * `['flyway']['confs']["#{config_id}"]['jdbc_username']`: The user used for communicating with the database
 * `['flyway']['confs']["#{config_id}"]['jdbc_password']`: The password used for communicating with the database
 * `['flyway']['confs']["#{config_id}"]['migrations_url']`: An artifact containing your migrations. Expected to not be in any nested sub-directories.
 * `['flyway']['confs']["#{config_id}"]['migrations_strip_components']`: Remove the specified number of leading path elements when extracting the migrations artifact (default=0)
 * `['flyway']['confs']["#{config_id}"]['options']`: Options included in the generated flyway properties file

The following attributes can be utilized to trigger retrieving database username/password information from an encrypted data bag instead:

 * `['flyway']['confs']["#{config_id}"]['data_bag']`: Defining this attribute with a nested hash enables reading the database username/password from an encrypted data bag. If enabled, the values supplied by `['flyway']['confs']["#{config_id}"]['jdbc_username']` and `['flyway']['confs']["#{config_id}"]['jdbc_password']` will be ignored.
 * `['flyway']['confs']["#{config_id}"]['data_bag']['name']`: The name of the data bag to read from (required)
 * `['flyway']['confs']["#{config_id}"]['data_bag']['item']`: The name of the data bag item to read from (required)
 * `['flyway']['confs']["#{config_id}"]['data_bag']['secret_file']`: An optional secret file if the node's default secret file isn't to be used for decryption
 * `['flyway']['confs']["#{config_id}"]['data_bag']['jdbc_username_key']`: The identifier of the username field in the data bag (default='jdbc_username')
 * `['flyway']['confs']["#{config_id}"]['data_bag']['jdbc_password_key']`: The identifier of the password field in the data bag (default='jdbc_password')

# Recipes

### _install

Downloads and extracts flyway into an installation folder. Will also download and install optionally providing JDBC drivers.

### default

Performs the installation above, and also executes the migrations against the configured database.

# Resources

 * `flyway_cli`: Downloads and install the flyway command line tool, and will also run migrations against a database.

## Actions

 * `install`: Downloads and installs the flyway command line tool
 * `migrate`: Runs the migrations against a database

### :install

Attribute parameters for install:

 * `install_java`: Triggers installation of java (default=`node['flyway']['use_java_recipe']`)
 * `flyway_user`: The user that will own and run the flyway process (default=`node['flyway']['user']`)
 * `flyway_group`: The group the flyway user will be a part of (default=`node['flyway']['group']`)
 * `create_user`: Flag determining whether the flyway user and group should be created during installation (default=`node['flyway']['create_user']`)
 * `install_path`: The installation path for the CLI (default='/opt/flyway' or 'C:\flyway', depending on platform)
 * `version`: The version of the flyway CLI to install (default=`node['flyway']['version']`)
 * `flyway_url`: A direct url for downloading the flyway cli artifact. If provided, `version` is ignored
 * `jdbc_driver`: The url for an optionally included JDBC driver

### :migrate

Attribute parameters for migrate:

 * `flyway_user`: The user that will own flyway migrations, should match the user from installation (default=`node['flyway']['group']`)
 * `flyway_group`: The group the flyway user will be a part of (default=`node['flyway']['group']`)
 * `migrations_path`: The path where migrations are installed (default=`node['flyway']['migrations_path']`)
 * `migrations_url`: An artifact containing your migrations
 * `migrations_strip_components`: Remove the specified number of leading path elements when extracting the migrations artifact (default=0)
 * `options`: Options to be included in the generated flyway properties file
 * `db_url`: The url used for communicating with the database (required)
 * `db_username`: The user used for communicating with the database (required)
 * `db_password`: The password used for communicating with the database (required)

# Contributors

Giovanni Toraldo [@gionn](https://github.com/gionn)

Manuel Mazzuola [@manuelmazzuola](https://github.com/manuelmazzuola)

Edward 'Cole' Skoviak [@EdwardSkoviak](https://github.com/EdwardSkoviak)

# License

Copyright 2014 ClouDesire

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
