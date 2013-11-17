require 'httpi'
require 'socket'
require 'timeout'
require 'json'

require_relative 'logger'
require_relative 'response'

module Rubot
  class APIError < StandardError
  end

  # API client
  class Client
    def self.valid_username?(name)
      name =~ /\A[0-9a-zA-Z]{10,40}\z/
    end

    # Search for a Hue hub, with configurable timeout.
    #
    # This sends out a broadcast packet with UDP, and waits for
    # a response from the Hue hub.
    #
    # @param [Integer] timeout seconds until giving up
    # @raise [TimeoutError] in case timeout is reached
    # @return [host]
    def self.discover(timeout = 5)
      Rubot::logger.info("Discovering Hubs...")
      socket  = UDPSocket.new(Socket::AF_INET)
      payload = []
      payload << "M-SEARCH * HTTP/1.1"
      payload << "HOST: 239.255.255.250:1900"
      payload << "MAN: ssdp:discover"
      payload << "MX: 10"
      payload << "ST: ssdp:all"
      socket.send(payload.join("\n"), 0, "239.255.255.250", 1900)

      Timeout.timeout(timeout, TimeoutError) do
        loop do
          message, (_, _, hue_ip, _) = socket.recvfrom(1024)
          # TODO: improve this. How do we know it’s a Hue hub?
          if message =~ /description\.xml/
            Rubot::logger.info("Discovered Hub: #{hue_ip}")
            return hue_ip
          end
        end
      end
    end

    # @return [String]
    attr_reader :host

    # @return [String]
    attr_reader :username

    # Create a Hue client. You’ll need a Hue hub
    # username for this, created via a POST to the
    # /api endpoint. See README for more information.
    #
    # @param [String] host - obtained from discover
    # @param [String] username
    def initialize(host, username)
      unless self.class().valid_username?(username)
        raise ArgumentError, "invalid username, must be length 10-40, only numbers and letters"
      end

      @host = host
      @username = username
    end

    # Creates a new user.
    # The link button on the bridge must be pressed and this command executed within 30 seconds.
    # Once a new user has been created, the user key is added to a ‘whitelist’, allowing access to API commands that require a whitelisted user.
    # At present, all other API commands require a whitelisted user.
    # We ask that published apps use the name of their app as the devicetype.
    #
    # @param [String] device_type used as device name
    # @raise [APIError] if failed
    def create_user(device_type)
      response = request(:post, "http://#{host}/api", JSON.dump( username: username, devicetype: device_type ))
      tap { raise APIError, response.error_messages.join(", ") if response.error? }
    end

    # @return [Boolean] true if username is in whitelist.
    def whitelist?
      # TODO perf?
      not get("/").error?
    end

    # Gets a list of all lights that have been discovered by the bridge.
    def lights
      get("/lights")
    end

    # Allows the user to turn the light on and off, modify the hue and effects.
    def set_light_state(id, state)
      put("lights/#{id}/state", state)
    end

    protected

    def get(path)
      request(:get, url(path))
    end

    def post(path, data)
      request(:post, url(path), JSON.dump(data))
    end

    def put(path, data)
      request(:put, url(path), JSON.dump(data))
    end

    def delete(path)
      request(:delete, url(path))
    end

    # @param [String] path
    # @return [String] full url
    def url(path)
      "http://#{host}/api/#{username}/#{path.to_s.sub(/\A\//, "")}"
    end

    ## TODO add flow limit control
    # @param [:get|:post|:put|:delete] method HTTP method
    # @param [String] url full url
    def request(method, url, *args)
      response = HTTPI.send(method, url, *args)
      Response.new(response)
    end
  end
end