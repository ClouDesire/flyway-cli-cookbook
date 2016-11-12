
db_connection_info = {:host => node['postgresql']['config']['listen_addresses'],
                     :username => 'postgres',
                     :password => node['postgresql']['password']['postgres']}

postgresql_database 'test' do
  connection db_connection_info
  action :create
end

postgresql_database 'pippo' do
  connection db_connection_info
  action :create
end

postgresql_database 'pippo2' do
  connection db_connection_info
  action :create
end

postgresql_database_user 'flyway' do
  connection db_connection_info
  password 'flyway'
  database_name 'test'
  host node['postgresql']['config']['listen_addresses']
  privileges [:all]
  action [:create, :grant]
end

postgresql_database_user 'pippo' do
  connection db_connection_info
  password 'pippo'
  database_name 'pippo'
  host node['postgresql']['config']['listen_addresses']
  privileges [:all]
  action [:create, :grant]
end

postgresql_database_user 'flyway' do
  connection db_connection_info
  password 'flyway'
  database_name 'pippo2'
  host node['postgresql']['config']['listen_addresses']
  privileges [:all]
  action [:grant]
end

migrations = '/tmp/migrations.tar.gz'

cookbook_file migrations do
  source 'migrations.tar.gz'
end

options = {'flyway.table' => 'schema_version_2'}
flyway_cli 'test' do
  action [:install, :migrate]
  install_path '/opt/flyway2'
  migrations_path '/opt/flyway2/sql'
  db_url 'jdbc:postgresql://localhost:5432/test'
  db_user 'flyway'
  db_password 'flyway'
  jdbc_driver 'http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/9.3-1100-jdbc4/postgresql-9.3-1100-jdbc4.jar'
  migrations_url "file:///#{migrations}"
  options options
end
