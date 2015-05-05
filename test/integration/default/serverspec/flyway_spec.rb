require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/opt/flyway/conf/flyway.properties') do
  it { should be_file }
  it { should contain "flyway.url" }
end

describe command('java -version') do
  its(:exit_status) { should eq 0 }
end

describe command('/opt/flyway/flyway') do
  its(:exit_status) { should eq 0 }
end
