module Recipes
  class ValidateUserInput
    attr_reader :ingredients, :diet_type, :llm_service, :llm_parser

    def initialize(ingredients:, diet_type: nil, llm_service: LlmChats::Groq::Ask.new, llm_parser: LlmChats::Groq::ParseResponse)
      @ingredients = ingredients
      @diet_type = diet_type
      @llm_service = llm_service
      @llm_parser = llm_parser
    end

    def call
      response = validate_llm_ingredients
      parsed_response = parsed_response(response)

      return if parsed_response["valid"]

      raise Errors::Recipes::InvalidUserInputError.new(parsed_response["invalid_items"])
    end

    private

    def validate_llm_ingredients
      llm_service.call(content: content, temperature: 0.5)
    end

    def content
      Recipes::Prompts::ValidateUserInput.prompt(ingredients: ingredients, diet_type: diet_type)
    end

    def parsed_response(response)
      llm_parser.new(response: response).parse_to_json
    end
  end
end
