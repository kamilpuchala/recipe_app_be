module Recipes
  class Create
    attr_reader :ingredients, :diet_type, :llm_service, :llm_parser

    def initialize(ingredients:, diet_type:, llm_service: LlmChats::Groq::Ask.new, llm_parser: LlmChats::Groq::ParseResponse)
      @ingredients = ingredients
      @diet_type = diet_type
      @llm_service = llm_service
      @llm_parser = llm_parser
    end

    def call
      response = create_recipe
      parsed_response = parsed_response(response)

      validate_recipe_output(parsed_response)

      parsed_response
    end

    private

    def create_recipe
      llm_service.call(content: recipe_content, temperature: 0.8)
    end

    def recipe_content
      Recipes::Prompts::Create.prompt(ingredients, diet_type)
    end

    def validate_recipe_output(recipe)
      response = llm_service.call(content: validate_recipe_output_content(recipe), temperature: 0.7)

      return if parsed_response(response)["valid"]

      raise Errors::Recipes::InvalidRecipeOutputError.new(parsed_response(response)["reasons"])
    end

    def validate_recipe_output_content(response)
      Recipes::Prompts::ValidateRecipeOutput.prompt(response)
    end

    def parsed_response(response)
      llm_parser.new(response: response).parse_to_json
    end
  end
end
