require 'logger'

module Rubot
  def self.logger
    @@logger ||= Logger.new(STDOUT)
    @@logger
  end
end