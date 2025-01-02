module LlmChats
  class Base
    attr_reader :client

    def initialize(client: nil)
      raise ArgumentError, "client is required" if client.nil?

      @client = client
    end

    def call
      raise NotImplementedError
    end
  end
end
