
db_connection_info = {:host => node['postgresql']['config']['listen_addresses'],
                     :username => 'postgres',
                     :password => node['postgresql']['password']['postgres']}


node['flyway']['confs'].each do |key, confs|

  postgresql_database key do
    connection db_connection_info
    action :create
  end

  user = confs['jdbc_username']
  password = confs['jdbc_password']


  if confs['use_data_bag']
    # Grab the databag
    encrypted_data_bag = Chef::EncryptedDataBagItem.load(confs['data_bag_name'],
                                                         confs['data_bag_item'])

    user = encrypted_data_bag['jdbc_username']
    password = encrypted_data_bag['jdbc_password']
  end

  postgresql_database_user user do
    connection db_connection_info
    password password
    database_name key
    host node['postgresql']['config']['listen_addresses']
    privileges [:all]
    action [:create, :grant]
  end

  file "/opt/flyway/sql/#{key}/V1__init.sql" do
    content "CREATE TABLE #{key} ( id integer PRIMARY KEY );"
  end
end
