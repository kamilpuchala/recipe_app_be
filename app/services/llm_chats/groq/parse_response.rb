module LlmChats
  module Groq
    class ParseResponse < LlmChats::Base
      attr_reader :response
      def initialize(response:)
        @response = response
      end

      def parse_to_text
        response["choices"][0]["message"]["content"]
      end

      def parse_to_json
        JSON.parse(parse_to_text)
      end
    end
  end
end
