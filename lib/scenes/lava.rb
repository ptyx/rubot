require_relative '../rubot/scene'
require_relative '../rubot/color'

# Red and variations thereof with slow transitions
class Lava < Rubot::Scene

  def initialize(*args)
    super(*args)

    @random = Random.new
    opts[:sleep] ||= 1
  end

  def run
    lights.each do |light|
      light.state = { "xy" => get_color,  "bri" => get_brightness, "transitiontime" => 10 }
    end
  end

  def get_color
    base = Rubot::RED.xy.dup
    base[1] = base[1] + 0.05 * @random.rand()
    base
  end

  def get_brightness
    puts "HB"
    return  50 + @random.rand(150)
  end
end