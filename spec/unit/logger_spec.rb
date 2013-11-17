require_relative '../../lib/rubot/logger'

describe 'logger' do
  it "should log" do
    Rubot::logger().info("Any log")
  end
end
