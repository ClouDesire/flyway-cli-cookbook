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

include_recipe "flyway-cli::migrate"
```
# Attributes

```
node[:flyway][:version] = "2.1.1"
node[:flyway][:installation_path] = "/opt/flyway"
node[:flyway][:migrations_path] = "/opt/flyway/sql"
node[:flyway][:jdbc_driver][:postgresql][:version] = "9.3-1100-jdbc4"
node[:flyway][:jdbc_driver][:mysql][:version] = "5.1.28"

node[:flyway][:confs] = {
    :default => {
        :jdbc_url => "jdbc:postgresql://localhost:5432/database",
        :jdbc_username => "username",
        :jdbc_password => "password"
    },
    :default2 => {
        :jdbc_url => "jdbc:postgresql://localhost:5432/database2",
        :jdbc_username => "username2",
        :jdbc_password => "password2"
    }
}

## Determines if the Opscode Java recipe is included
node[:flyway][:include_java_recipe] = true
```

# Recipes

## default

Download flyway, extract it in a folder, download jdbc driver for mysql and postgres, generate configs for the requested databases.

## migrate

Launch migrations for every configured database.

# Author

Giovanni Toraldo (<giovanni.toraldo@cloudesire.com>)
