module LlmChats
  module Groq
    class Ask < LlmChats::Base
      attr_reader :client

      BASE_MODEL = "llama3-8b-8192"
      ALLOWED_ROLES = %w[user assistant]

      def initialize(client: ::ExternalServices::Llm::Chat::Groq.new.client)
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

      def valid_role(role)
        return role if role_valid?(role)

        raise ArgumentError, "Invalid role"
      end

      def role_valid?(role)
        ALLOWED_ROLES.include?(role)
      end

      def valid_content(content)
        return content if content_valid?(content)

        raise ArgumentError, "Invalid content"
      end

      def content_valid?(content)
        content.is_a?(String) && content.present?
      end

      def valid_temperature(temperature)
        return temperature if temperature_valid?(temperature)

        raise ArgumentError, "Invalid temperature"
      end

      def temperature_valid?(temperature)
        temperature.is_a?(Float) && temperature.between?(0.0, 1.0)
      end
    end
  end
end
