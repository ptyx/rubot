require_relative 'client'
require_relative 'light'

module Rubot
  # Parent container for all ligths, groups, etc...
  class Hue
    # @return [Client] hue host
    attr_reader :client

    # @return [Lights] lights
    attr_reader :lights
    # @param [Client] client client
    def initialize(client)
      @client = client
      @lights = Lights.new
      client.lights.data.each do |key, value|
        @lights << Light.new(client,key,value["name"])
      end
    end
  end
end