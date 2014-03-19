execute "do migrations" do
  command node[:flyway][:installation_path] + "/flyway migrate -initOnMigrate=" + node[:flyway][:init_on_migrate]
end
