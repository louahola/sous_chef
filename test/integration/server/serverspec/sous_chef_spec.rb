require 'spec_helper'

# Jenkins Service
## Check for service running
describe service('jenkins') do
  it { should be_running }
  it { should be_enabled }
end

describe port(8080) do
  it { should be_listening }
end
