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

```
# Attributes

```
node[:flyway][:version] = "2.1.1"
node[:flyway][:jdbc_driver][:postgresql][:version] = "9.3-1100-jdbc4"
node[:flyway][:jdbc_driver][:mysql][:version] = "5.1.28"
node[:flyway][:jdbc_driver][:jtds][:version] = "1.3.1"

node[:flyway][:confs] = {
    :default => {
        :jdbc_url => "jdbc:postgresql://localhost:5432/database",
        :jdbc_username => "username",
        :jdbc_password => "password"
    },
    :default2 => {
        :jdbc_url => "jdbc:jtds:sqlserver://localhost/database2",
        :jdbc_username => "username2",
        :jdbc_password => "password2"
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

