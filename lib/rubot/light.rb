module Rubot
  class Light
    attr_reader :logger
    # @return [Client] client
    attr_reader :client
    # @return [String] light id
    attr_reader :id
    # @return [String] light name
    attr_reader :name
    def initialize(client, id, name)
      @logger = Rubot::logger
      @client = client
      @id = id
      @name = name
    end

    def state=(state)
      @logger.info( "#{self} < #{state}")
      client.set_light_state(id, state)
    end

    def to_s
      "#{name}(#{id})"
    end
  end

  # A set of lights - handle as an array, but adds convenience methods for mass access
  class Lights < Array
    def select(*args)
      return Lights.new(super(*args))
    end

    def state=(state)
      each{ |light| light.state = state }
    end

    def to_s
      "[" + collect{ |light| light.to_s }.join(",") + "]"
    end
  end
end