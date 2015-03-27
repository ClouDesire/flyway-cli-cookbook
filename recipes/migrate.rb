
include_recipe "flyway-cli::default"


installation_path = node[:flyway][:installation_path]

# Flyway don't care if platform is windows or linux
migrations_path = node[:flyway][:migrations_path].gsub(/\\/, '/')

# Why JAVA_HOME is not already set ?
windows_batch 'set_java_home' do
  code <<-EOH
  set JAVA_HOME=#{node[:java][:java_home]}
  EOH
end

node[:flyway][:confs].each do |key, confs|
  file installation_path + "/conf/#{key}.properties" do
    action :create
    content <<-EOH
flyway.url=#{confs[:jdbc_url]}
flyway.user=#{confs[:jdbc_username]}
flyway.password=#{confs[:jdbc_password]}
flyway.locations=filesystem:#{migrations_path}
    EOH
  end

  execute "do migrations" do
    command installation_path + "/flyway migrate -configFile=#{installation_path}/conf/#{key}.properties -initOnMigrate=" + node[:flyway][:init_on_migrate]
  end
end
