
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.utf-8"
include_recipe "postgresql::server"
include_recipe "database::postgresql"

db_connection_info = {:host => node[:postgresql][:config][:listen_addresses],
                     :username => 'postgres',
                     :password => node[:postgresql][:password][:postgres]}


node[:flyway][:confs].each do |key, confs|

    postgresql_database key do
      connection db_connection_info
      action :create
    end

    postgresql_database_user confs[:jdbc_username] do
      connection db_connection_info
      password confs[:jdbc_password]
      database_name key
      host node[:postgresql][:config][:listen_addresses]
      privileges [:all]
      action [:create, :grant]
    end

    file "/opt/flyway/sql/#{key}/V1__init.sql" do
        content "CREATE TABLE #{key} ( id integer PRIMARY KEY );"
    end
end
