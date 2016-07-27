flyway-cli-cookbook
===================

[![Build Status](https://travis-ci.org/ClouDesire/flyway-cli-cookbook.svg?branch=master)](https://travis-ci.org/ClouDesire/flyway-cli-cookbook)

This cookbook configure the CLI version of the flyway tool, and support multiple databases.

# Requirements

An already configured database, and a bunch of flyway migrations.

# Usage

```
include_recipe "flyway-cli::default"

## put your migrations in node[:flyway][:migrations_path]
## run migrate

flyway_migrate

### (Optional) Setup the Encrypted Data Bag

Your data bag should look like this,

    {
      "id": "[YOUR_ID_DONT_EDIT]",
      "jdbc_username": "USER",
      "jdbc_password": "PASSWORD",
    }

```
# Attributes

```
node[:flyway][:version] = "2.1.1"
node[:flyway][:jdbc_driver][:postgresql][:version] = "9.3-1100-jdbc4"
node[:flyway][:jdbc_driver][:mysql][:version] = "5.1.28"
node[:flyway][:jdbc_driver][:jtds][:version] = "1.3.1"

# optional attributes to define the user/group for the properties files containing database login credentials. defaults to executing user.
node[:flyway][:user] 
node[:flyway][:group] 

# set the permissions for the properties files. defaults to '0640'
node[:flyway][:properties_permissions] = 0640

node[:flyway][:confs] = {
    :default => {
        :jdbc_url => "jdbc:postgresql://localhost:5432/database",
        :jdbc_username => "username",
        :jdbc_password => "password"
    },
    :default2 => {
        :jdbc_url => "jdbc:jtds:sqlserver://localhost/database2",

        # if a data bag is used, data bag name and item must be configured
        :use_data_bag => true,
        :data_bag_name => "data_bag",
        :data_bag_item => "data_bag_item"

        # optionally provide the path to the data bags secret file
        :data_bag_secret_path => "/etc/chef/secret_file"
    }
}

## Determines if the Opscode Java recipe is included
node[:flyway][:include_java_recipe] = true
```

# Recipes

## default

Download flyway, extract it in a folder, download jdbc driver for mysql, postgres and sql server, generate configs for the requested databases.

## migrate - DEPRECATED

Use ``flyway_migrate`` resource to launch migrations for every configured database.

# Authors

Giovanni Toraldo @gionn
Manuel Mazzuola @manuelmazzuola

