require_relative '../../lib/rubot/rubot'
require_relative '../../lib/scenes/paintshop'
require_relative '../../lib/scenes/lava'
require_relative '../../lib/scenes/holiday'

describe 'hue' do
  before :all do
    @host = "192.168.1.68"
    @client = Rubot::Client.new(@host, "rubot0test")
    @hue = Rubot::Hue.new(@client)
  end

  it "can play with lights" do
    puts @hue.lights()

    #    @hue.lights().select{ |light| light.name == "Media Center Right"}.each do |light|
    #      for  i in 0..65
    #        light.state = { "hue" => i * 1000 , "sat" => 255 }
    #        sleep(1)
    #      end
    #    end

    lights = @hue.lights().select{ |light| light.name.match(/Outside/) }
    puts lights
    j = 0
    #    for  i in 0..10
    #      lights.each do |light|
    #        j = j+1
    #        if (i + j) % 2 == 0
    #          # The hue value is a wrapping value between 0 and 65535. Both 0 and 65535 are red, 25500 is green and 46920 is blue.
    #          hue = 25500
    #        else
    #          hue = 0
    #        end
    #        light.state = { "hue" => hue, "sat" => 255 }
    #      end
    #      sleep(1)
    #    end
  end

  #  it "can flicker" do
  #    lights = @hue.lights().select{ |light| light.name.match(/Media/) }
  #
  #    lights.state = { "bri" => 100 }
  #    sleep(1)
  #    lights.state = { "bri" => 50, "transitiontime" => 1 }
  #    sleep(0.1)
  #    lights.state = { "bri" => 250, "transitiontime" => 1 }
  #    sleep(0.1)
  #    lights.state = { "bri" => 100, "transitiontime" => 2 }
  #  end

  it "can breathe" do
    lights = @hue.lights().select{ |light| light.name.match(/Media/) }

    lights.state = { "bri" => 100 }
    #    for i in 1..10
    #      sleep(1)
    #      lights.state = { "bri" => 50, "transitiontime" => 30 }
    #      sleep(3)
    #      lights.state = { "bri" => 150, "transitiontime" => 30 }
    #      sleep(3)
    #      lights.state = { "bri" => 100, "transitiontime" => 30 }
    #      sleep(3)
    #    end
  end

  it "can breathe again" do
    lights = @hue.lights().select{ |light| light.name.match(/Media/) }

    #    scene = PaintShop.new(lights, {:delay => 5, :until => Time.now  + 40})
    #    scene.start()
    #    sleep(40)

    scene = Lava.new(lights, {:delay => 5, :until => Time.now  + 40})
    scene.start()
    sleep(40)

    scene = Holiday.new(lights)
    scene.start();
    sleep(40)
  end
end
