module Recipes
  class ValidateIngredients
    attr_reader :ingredients, :llm_service, :llm_parser

    def initialize(ingredients:, llm_service: LlmChats::Groq::Ask.new, llm_parser: LlmChats::Groq::ParseResponse)
      @ingredients = ingredients
      @llm_service = llm_service
      @llm_parser = llm_parser
    end

    def call
      response = validate_llm_ingredients
      parsed_response = parsed_response(response)

      return if parsed_response["valid"]

      raise Errors::Recipes::InvalidIngredientsInputError.new(parsed_response["invalid_items"])
    end

    private

    def validate_llm_ingredients
      llm_service.call(content: content, temperature: 0.7)
    end

    def content
      Recipes::Prompts::ValidateIngredients.prompt(ingredients)
    end

    def parsed_response(response)
      llm_parser.new(response: response).parse_to_json
    end
  end
end
