module ExternalServices
  module Llm
    module Chat
      class Groq
        URI_BASE = "https://api.groq.com/openai"
        def self.client(uri_base: URI_BASE)
          OpenAI::Client.new(
            access_token: ENV["OPENAI_GROQ_API_KEY"],
            uri_base: uri_base
          )
        end
      end
    end
  end
end
