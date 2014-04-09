require 'spec_helper'

describe file('/opt/flyway/conf/flyway.properties') do
  it { should be_file }
  it { should contain "flyway.url" }
end

describe command('java -version') do
  it { should return_exit_status 0 }
end

describe command('/opt/flyway/flyway') do
  it { should return_exit_status 0 }
end
