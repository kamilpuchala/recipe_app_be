module LlmChats
  module Groq
    class Ask < LlmChats::Base
      attr_reader :client

      BASE_MODEL = "llama3-8b-8192"
      ALLOWED_ROLES = %w[user assistant]
      ALLOWED_PARSED_RESPONSE_TYPES = %w[json text raw]

      def initialize(client: ::ExternalServices::Llm::Chat::Groq.client)
        super
      end

      def call(model: BASE_MODEL, role: "user", content: nil, temperature: 1.0, response_format: "json_object")
        client.chat(
          parameters: {
            model: model,
            response_format: ({type: "json_object"} if response_format == "json_object"),
            messages: [
              {
                role: valid_role(role),
                content: valid_content(content)
              }
            ],
            temperature: valid_temperature(temperature)
          }.compact
        )
      end

      private

      def parsed_response_text(response)
        response["choices"][0]["message"]["content"]
      end

      def valid_role(role)
        raise ArgumentError, "Invalid role" unless role_valid?(role)

        role
      end

      def role_valid?(role)
        ALLOWED_ROLES.include?(role)
      end

      def valid_content(content)
        raise ArgumentError, "Invalid content" unless content_valid?(content)

        content
      end

      def content_valid?(content)
        content.is_a?(String) && content.present?
      end

      def valid_temperature(temperature)
        raise ArgumentError, "Invalid temperature" unless temperature_valid?(temperature)

        temperature
      end

      def temperature_valid?(temperature)
        temperature.is_a?(Float) && temperature.between?(0.0, 1.0)
      end
    end
  end
end
