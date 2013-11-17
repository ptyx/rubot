require_relative '../rubot/scene'

# Holiday show - red, green and white
class Holiday < Rubot::Scene
  def initialize(*args)
    super(*args)

    @random = Random.new
    opts[:sleep] ||= 10
  end

  def run
    lights.each do |light|
      hue = @random.rand(65536)
      light.state = { "hue" => hue, "sat" => 255 }
    end
  end
end