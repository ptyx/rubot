require_relative 'hue'

module Rubot
  class Color
    attr_reader :hue
    attr_reader :sat
    attr_reader :xy
    attr_reader :ct
    def initialize( values )
      @hue = values[:hue] % 65536 unless values[:hue].nil?
      @sat = values[:sat]         unless values[:sat].nil?
      @xy = values[:xy].freeze()  unless values[:xy].nil?
      @ct = values[:ct]           unless values[:ct].nil?

      if (xy.nil? || sat.nil?) && hue.nil? && ct.nil?
        raise "Cannot convert values to color: #{values}"
      end
    end

    # @return [Hash] a color state
    def state
      return {"hue" => hue, "sat" => sat} unless hue.nil?
      return {"xy" => xy} unless xy.nil?
      return {"ct" => ct} unless ct.nil?
    end
  end

  GREEN = Color.new( :hue => 25500, :sat => 255 )
  RED = Color.new( :hue => 0, :sat => 255, :xy => [0.675,0.322] )
  BLUE = Color.new( :hue => 46920, :sat => 255 )
  WHITE = Color.new( :ct => 153 )
end
