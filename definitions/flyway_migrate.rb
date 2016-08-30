
define :flyway_migrate do

  include_recipe "flyway-cli::default"

  installation_path = node['flyway']['installation_path']

  # Flyway don't care if platform is windows or linux
  migrations_path = node['flyway']['migrations_path'].gsub(/\\/, '/')

  node['flyway']['confs'].each do |key, confs|
    url = confs['jdbc_url']
    user = confs['jdbc_username']
    password = confs['jdbc_password']

    if confs[:use_data_bag]
      # Grab the encrypted data bag
      encrypted_data_bag = nil
      if confs.attribute?('data_bag_secret_path')
        encrypted_data_bag = Chef::EncryptedDataBagItem.load(confs['data_bag_name'],
                                                            confs['data_bag_item'],
                                                            Chef::EncryptedDataBagItem.load_secret(confs['data_bag_secret_path']))
      else
        encrypted_data_bag = Chef::EncryptedDataBagItem.load(confs['data_bag_name'],
                                                            confs['data_bag_item'])
      end

      user = encrypted_data_bag['jdbc_username']
      password = encrypted_data_bag['jdbc_password']
    end

    raise "username not defined for #{key} (using databag=#{confs['use_data_bag']}" unless user
    raise "password not defined for #{key} (using databag=#{confs['use_data_bag']}" unless password

    template "#{installation_path}/conf/#{key}.properties" do
      cookbook node['flyway']['properties_template_cookbook']
      source 'flyway.properties.erb'
      mode node['flyway']['properties_permissions']
      # if user/group not overridden, will default to executing user
      owner node['flyway']['user']
      group node['flyway']['group']
      variables(
        url: url,
        user: user,
        password: password,
        migrations_path: migrations_path,
        key: key,
        java_home: node['java']['java_home'],
        options: confs['options']
      ) 
    end

    flyway_command = installation_path + "/flyway migrate -configFile=#{installation_path}/conf/#{key}.properties -initOnMigrate=" + node['flyway']['init_on_migrate']

    if platform?("windows")
      windows_batch 'set_java_home_and_run_flyway' do
        code <<-EOH
        set JAVA_HOME=#{node['java']['java_home']}
        #{flyway_command}
        EOH
      end
    else
      execute "do migrations" do
        command flyway_command
      end
    end
  end
end
