if platform_family?('windows')
  default['flyway']['installation_path'] = 'C:\\flyway'
  default['flyway']['migrations_path'] = 'C:\\flyway\\sql'
else
  default['flyway']['installation_path'] = '/opt/flyway'
  default['flyway']['migrations_path'] = '/opt/flyway/sql'
end

default['flyway']['version'] = '3.2.1'
default['flyway']['create_user'] = true
default['flyway']['user'] = 'flyway'
default['flyway']['group'] = 'flyway'
default['flyway']['include_java_recipe'] = true
default['flyway']['old_base_url'] = 'http://repo1.maven.org/maven2/com/googlecode/flyway/flyway-commandline/VERSION/flyway-commandline-VERSION.tar.gz'
default['flyway']['base_url'] = 'http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/VERSION/flyway-commandline-VERSION.tar.gz'

default['flyway']['confs'] = {}
