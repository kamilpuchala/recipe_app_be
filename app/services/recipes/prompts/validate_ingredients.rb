module Recipes
  module Prompts
    class ValidateIngredients
      PROMPT_TEMPLATE = <<~PROMPT
        The user provided the following input: %{ingredients}.
        Validate if each item in the input list is a valid ingredient commonly used in recipes.
        - Consider typical produce (fruits, vegetables), proteins (meats, fish, eggs, tofu), pantry staples (flour, sugar, salt, pepper, oils), dairy, spices, condiments, grains (including pasta, rice, oats), and any other standard grocery or brand-name item as valid.
        If any item is not a valid ingredient, return a list of the invalid items with short explenation why, as we show you in example response.

        Return your response strictly as a JSON object in the format:

        {
          "valid": true
        }

        or:

        {
          "valid": false,
          "invalid_items": [
                              "<invalid_item_1>: shortly explain why item is invalid in your opinion",
                              "<invalid_item_2>: shortly explain why item is invalid in your opinion",
                              ...
                ]
        }

        Do not include any additional text or explanations, only pure JSON as in given example!
      PROMPT

      def self.prompt(ingredients)
        PROMPT_TEMPLATE % {ingredients: ingredients}
      end
    end
  end
end
