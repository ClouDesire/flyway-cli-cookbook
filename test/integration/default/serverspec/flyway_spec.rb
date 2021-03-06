require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/opt/flyway/conf/pippo.properties') do
  it { should be_file }
  it { should contain 'flyway.url' }
  it { should contain 'flyway.user=pippo' }
  it { should contain 'flyway.password=pippo' }
  it { should contain 'flyway.locations' }
  it { should contain 'java.home' }
end

describe file('/opt/flyway/conf/pippo2.properties') do
  it { should be_file }
  it { should contain 'flyway.url' }
  it { should contain 'flyway.user=flyway' }
  it { should contain 'flyway.password=flyway' }
  it { should contain 'flyway.locations' }
  it { should contain 'java.home' }
  it { should contain 'flyway.table=alternate_schema_version' }
  it { should contain 'flyway.encoding=UTF-8' }
end

describe file('/opt/flyway2/conf/test.properties') do
  it { should be_file }
  it { should contain 'flyway.url' }
  it { should contain 'flyway.user=flyway' }
  it { should contain 'flyway.password=flyway' }
  it { should contain 'flyway.locations' }
  it { should contain 'java.home' }
  it { should contain 'flyway.table=schema_version_2' }
end

describe command('java -version') do
  its(:exit_status) { should eq 0 }
end

describe command('/opt/flyway/flyway') do
  its(:exit_status) { should eq 0 }
end
