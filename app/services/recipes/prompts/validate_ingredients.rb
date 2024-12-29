module Recipes
  module Prompts
    class ValidateIngredients
      PROMPT_TEMPLATE = <<~PROMPT
        The user provided the following input: %{ingredients}.
        Validate if each item in the input list is a valid ingredient commonly used in recipes.
        If any item is not a valid ingredient, return a list of the invalid items.

        Return your response strictly as a JSON object in the format:

        {
          "valid": true
        }

        or:

        {
          "valid": false,
          "invalid_items": ["<invalid_item_1>", "<invalid_item_2>", ...]
        }

        Do not include any additional text or explanations, only pure JSON as in given example!
      PROMPT

      def self.prompt(ingredients)
        PROMPT_TEMPLATE % {ingredients: ingredients}
      end
    end
  end
end
