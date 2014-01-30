flyway-cli-cookbook
===================

This cookbook configure the CLI version of the flyway tool.

# Requirements

An already configured database, and a bunch of flyway migrations.

# Usage

```
include_recipe "flyway-cli::default"

## put your migrations in node[:flyway][:installation_path] + '/sql'

include_recipe "flyway-cli::migrate"
```
# Attributes

```
node[:flyway][:version] = "2.1.1"
node[:flyway][:installation_path] = "/opt/flyway"
node[:flyway][:jdbc_url] = "jdbc:postgresql://localhost:5432/database"
node[:flyway][:jdbc_username] = ""
node[:flyway][:jdbc_password] = ""
node[:flyway][:jdbc_driver][:postgresql][:version] = "9.3-1100-jdbc4"
node[:flyway][:jdbc_driver][:mysql][:version] = "5.1.28"
```

# Recipes

## default

Download flyway, extract it in a folder, download jdbc driver for mysql and postgres.

## migrate

Launch migrations.

# Author

Giovanni Toraldo (<giovanni.toraldo@cloudesire.com>)
