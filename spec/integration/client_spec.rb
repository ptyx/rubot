require_relative '../../lib/rubot/client'

describe 'client' do
  before :all do
    @host = Rubot::Client.discover(5)
    @client = Rubot::Client.new(@host, "rubot0test")
  end

  it "should discover" do
    @host.should_not be(nil)
  end

  it "should not have random users in whitelist" do
    client = Rubot::Client.new(@host, "unknown0username")
    client.whitelist?.should eq(false)
  end

  it "should have rubot whitelisted" do
    @client.whitelist?.should eq(true)
  end

  it "should find ligths" do
    @client.lights.data.size.should be >= 3
  end
end
