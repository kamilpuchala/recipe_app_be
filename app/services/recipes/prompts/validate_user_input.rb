# frozen_string_literal: true

module Recipes
  module Prompts
    class ValidateUserInput
      PROMPT_TEMPLATE = <<~PROMPT
        You are an experienced chef and a strict validator.

        The user provided the following:
        - Ingredients: %{ingredients}
        - Diet Type: "%{diet_type}"

        You must validate in three steps, returning **only** a JSON object. Absolutely no additional text.

        ---
        **STEP 1: Validate INGREDIENTS for edibility**
        - For each item in `ingredients`, check if it is a recognized edible grocery product (produce, meats, fish, eggs, tofu, grains, dairy, spices, condiments, oils, etc.).
        - Mark obviously inedible/nonsensical items (e.g., "macbook," "car tyre," "rock," "laptop") as invalid.
        - It's very important for us to be sure that we will create recipe only from valid ingredients!
        - If ANY `ingredient` fails, return immediately:
          {
            "valid": false,
            "invalid_items": [
              "invalid_ingredient: <item> explanation why it's invalid",
              ...
            ]
          }
        - Do NOT continue to steps 2 if step 1 fails.

        ---
        **STEP 2: Validate DIET TYPE restrictions** (skip if 'diet_type' is "None" or empty)
        - If "keto": Disallow high-carb items like sugar, honey, wheat flour, bread, pasta, potatoes, etc. Allow meats, eggs, fish, dairy, eggs, nuts, seeds, oils, low-carb etc. vegetables as they are keto friendly.
        - If "vegan": Disallow meat, fish, dairy, eggs, honey, or any animal-derived ingredient. Allow fruits, vegetables, grains, legumes, nuts, seeds, oils, etc. as they are vegan friendly.
        - If ANY `ingredient` violates the diet rules, return:
          {
            "valid": false,
            "invalid_items": [
              "invalid_ingredient: <item> explanation why it's invalid in scope of the <diet_type> diet",
              ...
            ]
          }

        ---
        **FINAL RESULT**
        - If all steps pass (or steps are skipped appropriately), return:
          {
            "valid": true
          }

        **Important**: Return only pure JSON—no additional text or explanation.
      PROMPT

      def self.prompt(ingredients:, diet_type:)
        PROMPT_TEMPLATE % {
          ingredients: ingredients,
          diet_type: diet_type || "None"
        }
      end
    end
  end
end
