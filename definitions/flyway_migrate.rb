
define :flyway_migrate do

  include_recipe "flyway-cli::default"

  installation_path = node[:flyway][:installation_path]

  # Flyway don't care if platform is windows or linux
  migrations_path = node[:flyway][:migrations_path].gsub(/\\/, '/')

  node[:flyway][:confs].each do |key, confs|
    file installation_path + "/conf/#{key}.properties" do
      action :create
      content <<-EOH
flyway.url=#{confs[:jdbc_url]}
flyway.user=#{confs[:jdbc_username]}
flyway.password=#{confs[:jdbc_password]}
flyway.locations=filesystem:#{migrations_path}
java.home=#{node[:java][:java_home]}
EOH
    end

    flyway_command = installation_path + "/flyway migrate -configFile=#{installation_path}/conf/#{key}.properties -initOnMigrate=" + node[:flyway][:init_on_migrate]

    if platform?("windows")
      windows_batch 'set_java_home_and_run_flyway' do
        code <<-EOH
        set JAVA_HOME=#{node[:java][:java_home]}
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
