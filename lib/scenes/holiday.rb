require_relative '../rubot/scene'
require_relative '../rubot/color'

# All lights are set to random colors
# Repeats every :delay seconds
class Holiday < Rubot::Scene
  COLORS = [Rubot::RED, Rubot::GREEN, Rubot::WHITE]

  def initialize(*args)
    super(*args)

    @first_color = Random.new.rand(COLORS.size)
    opts[:sleep] ||= 10
  end

  def run
    light_color = @first_color
    @first_color += 1

    lights.each do |light|
      color = COLORS[light_color % COLORS.size]
      light_color += 1

      light.state = color.state
    end
  end
end