require_relative 'hue'

module Rubot
  class Scene
    attr_reader :logger
    attr_reader :lights
    attr_reader :opts
    # @param [Lights] lights at the start of the scene
    # @param [Hash] opts options
    #
    # Standard options are:
    # :sleep => time to sleep between each invocation of run()
    # :until => time to play the scene
    def initialize(lights, opts = {})
      @logger = Rubot.logger;
      @lights = lights
      @opts = opts
    end

    def start
      logger().info("Starting scene #{self}: #{lights}")

      @thread = Thread.new{
        before
        while lights.size > 0 && !until_reached
          run
          sleep(opts[:sleep]) unless opts[:sleep].nil?
        end
        after
      }
    end

    # Extend as needed
    def before

    end

    # Extend as needed
    def run
    end

    # Extend as needed
    def after

    end

    def to_s
      "#{self.class}#{opts}"
    end

    protected

    def until_reached
      return false if opts[:until].nil?
      return Time.now > opts[:until]
    end

  end
end
