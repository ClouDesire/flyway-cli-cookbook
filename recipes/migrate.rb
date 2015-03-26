
path = node[:flyway][:installation_path]
migrations_path = node[:flyway][:migrations_path]
node[:flyway][:confs].each do |key, confs|
  file path + "/conf/#{key}.properties" do
    owner "root"
    group "root"
    mode  "0755"
    action :create
    content <<-EOH
flyway.url=#{confs[:jdbc_url]}
flyway.user=#{confs[:jdbc_username]}
flyway.password=#{confs[:jdbc_password]}
flyway.locations=filesystem:#{migrations_path}
    EOH
  end

  execute "do migrations" do
    command path + "/flyway migrate -configFile=#{path}/conf/#{key}.properties -initOnMigrate=" + node[:flyway][:init_on_migrate]
  end
end
