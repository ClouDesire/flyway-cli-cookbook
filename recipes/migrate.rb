execute "do migrations" do
  command node[:flyway][:installation_path] + "/flyway.sh migrate"
end
