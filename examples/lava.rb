require '../lib/scenes/lava'

client = Rubot::Client.new("192.168.1.68", "rubot0test")
hue = Rubot::Hue.new(client)
lights = hue.lights.select{ |l| l.name.match(/Media/) }

lava = Lava.new(lights)
lava.start

begin
  sleep(10)
end while true
