require_relative '../../lib/rubot/hue'

describe 'hue' do
  before :all do
    @host = "192.168.1.68"
    @client = Rubot::Client.new(@host, "rubot0test")
    @hue = Rubot::Hue.new(@client)
  end

  it "should find ligths" do
    @hue.lights().size.should be >= 3
  end
end
