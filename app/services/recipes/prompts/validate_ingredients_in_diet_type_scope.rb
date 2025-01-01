# frozen_string_literal: true

module Recipes
  module Prompts
    class ValidateIngredientsInDietTypeScope
      PROMPT_TEMPLATE = <<~PROMPT
        You are an experienced chef.

        The user has specified a diet type: "%{diet_type}"
        The user provided the following ingredients: %{ingredients}.

        1. Validate if each item is a commonly recognized cooking ingredient or edible grocery product.
           - Consider typical produce (fruits, vegetables), proteins (meats, fish, eggs, tofu), pantry staples (flour, sugar, salt, pepper, oils), dairy, spices, condiments, grains (pasta, rice, oats), etc., as valid.
           - If the ingredient is obviously inedible or nonsensical (e.g. "laptop", "wooden spoon", "car tire"), mark it invalid.

        2. Validate if each ingredient is allowed under the specified diet type:
           - If "keto", disallow high-carb items (e.g. sugar, honey, syrups, wheat flour, bread, pasta, potatoes, etc.).
           - If "vegan", disallow any animal products (meat, fish, dairy, eggs, honey).
           - If "vegetarian", disallow any meat or fish (but eggs, dairy are okay).
           - Apply similar rules for other diet types if needed.

        If all items pass both checks, return strictly this JSON object:
        {
          "valid": true
        }

        If any item fails (either it's not a recognized ingredient or it violates the diet rules), return strictly this JSON object:
        {
          "valid": false,
          "invalid_items": [
            "invalid_ingredient: <item_1> explenation why it's invalid in scope of the diet",
            "invalid_ingredient: <item_2> explenation why it's invalid in scope of the diet",
            ...
          ]
        }

        Do NOT provide any additional text or explanations—only respond with the pure JSON.

      PROMPT

      def self.prompt(ingredients, diet_type)
        PROMPT_TEMPLATE % {diet_type: diet_type || "None", ingredients: ingredients}
      end
    end
  end
end
