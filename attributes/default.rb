default['flyway']['version'] = "3.2.1"

if platform_family?('windows')
  default['flyway']['installation_path'] = 'C:\\flyway'
  default['flyway']['migrations_path'] = 'C:\\flyway\\sql'
else
  default['flyway']['installation_path'] = '/opt/flyway'
  default['flyway']['migrations_path'] = '/opt/flyway/sql'
end

default['flyway']['jdbc_url'] = "jdbc:postgresql://localhost:5432/database" #deprecated
default['flyway']['jdbc_username'] = "" #deprecated
default['flyway']['jdbc_password'] = "" #deprecated
default['flyway']['jdbc_driver']['postgresql']['version'] = "9.3-1100-jdbc4"
default['flyway']['jdbc_driver']['mysql']['version'] = "5.1.28"
default['flyway']['jdbc_driver']['jtds']['version'] = "1.3.1"
default['flyway']['init_on_migrate'] = "false"
default['flyway']['include_java_recipe'] = true
default['flyway']['properties_permissions'] = 0640
default['flyway']['properties_template_cookbook'] = 'flyway-cli'

default['flyway']['version_installed'] = "0"
default['flyway']['old_base_url'] = "http://repo1.maven.org/maven2/com/googlecode/flyway/flyway-commandline/VERSION/flyway-commandline-VERSION.tar.gz"
default['flyway']['base_url'] = "http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/VERSION/flyway-commandline-VERSION.tar.gz"
default['flyway']['jdbc_driver']['postgresql']['url'] = "http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/VERSION/postgresql-VERSION.jar"
default['flyway']['jdbc_driver']['mysql']['url'] = "http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/VERSION/mysql-connector-java-VERSION.jar"
default['flyway']['jdbc_driver']['jtds']['url'] = "http://central.maven.org/maven2/net/sourceforge/jtds/jtds/VERSION/jtds-VERSION.jar"

default['flyway']['confs'] = {}

## For backward compatibility when only one database was supported
if ! (default['flyway']['jdbc_username'].empty? || default['flyway']['jdbc_password'].empty?)
    default['flyway']['confs']['flyway'] = {
        'jdbc_url' => default['flyway']['jdbc_url'],
        'jdbc_username' => default['flyway']['jdbc_username'],
        'jdbc_password' => default['flyway']['jdbc_password']
    }
end
