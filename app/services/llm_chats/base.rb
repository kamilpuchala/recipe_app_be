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

    private

    def parsed_response_text(response)
      raise NotImplementedError
    end

    def parsed_response_json(response)
      JSON.parse(parsed_response_text(response))
    end
  end
end
