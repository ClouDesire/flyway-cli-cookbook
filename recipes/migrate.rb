
path = node[:flyway][:installation_path]
node[:flyway][:confs].each do |key, confs|
    execute "do migrations" do
      command path + "/flyway migrate -configFile=#{path}/conf/#{key}.properties -initOnMigrate=" + node[:flyway][:init_on_migrate]
    end
end
