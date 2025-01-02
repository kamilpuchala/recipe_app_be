module ExternalServices
  module Llm
    module Chat
      class Groq
        URI_BASE = "https://api.groq.com/openai"
        attr_reader :access_token, :uri_base

        def initialize(access_token: ENV["OPENAI_GROQ_API_KEY"], uri_base: URI_BASE)
          @access_token = access_token
          @uri_base = uri_base
        end

        def client
          OpenAI::Client.new(
            access_token: access_token,
            uri_base: uri_base
          )
        end
      end
    end
  end
end
