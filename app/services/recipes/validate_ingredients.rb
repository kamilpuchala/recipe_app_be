module Recipes
  class ValidateIngredients
    attr_reader :ingredients, :llm_validator, :llm_parser
    def initialize(ingredients:, llm_validator: LlmChats::Groq::Ask.new, llm_parser: LlmChats::Groq::ParseResponse)
      @ingredients = ingredients
      @llm_validator = llm_validator
      @llm_parser = llm_parser
    end

    def call
      response = validate_llm_ingredients

      unless parsed_response(response)["valid"]
        raise Recipes::Prompts::ValidateIngredients::InvalidInput.new(parsed_response(response)["invalid_items"])
      end
    end

    private

    def validate_llm_ingredients
      llm_validator.call(content: content, temperature: 0.7)
    end

    def content
      Recipes::Prompts::ValidateIngredients.prompt(ingredients)
    end

    def parsed_response(response)
      llm_parser.new(response: response).parse_to_json
    end
  end
end

class Recipes::Prompts::ValidateIngredients::InvalidInput < StandardError
  def initialize(invalid_ingredients)
    super
  end
end
