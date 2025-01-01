# frozen_string_literal: true

module Recipes
  module Prompts
    class Create
      PROMPT_TEMPLATE = <<~PROMPT
        You are an experienced chef.

        Requirements:
        1. You MUST use exactly these required ingredients: %{ingredients}.
           - Each ingredient must include a quantity in the final JSON output.
           - The JSON structure for ingredients must be:
             "ingredients": [
               { "quantity": "...", "name": "..." },
               { "quantity": "...", "name": "..." }
             ]
        2. If there are any excluded ingredients, do NOT include them under any circumstance: %{excluded_ingredients}.
        3. If a diet type is specified (%{diet_type}), the final recipe must be suitable for that diet.
           - For example, if diet_type is "vegan" you cannot use any animal products;
             if "vegetarian" you cannot include meat or fish.

        If it is IMPOSSIBLE to build a recipe under these conditions
        (e.g., diet_type is "vegan" but a required ingredient is "chicken"),
        IT'S VERY IMPORTANT TO RETURN A JSON OBJECT WITH A "fail" KEY if DIET has exclusions and that ingredient is included.
        THEN RETURN ONLY THIS JSON (no extra text or formatting):
        {
          "fail": "Short explanation of why we can't build the recipe"
        }

        OTHERWISE, return ONLY this JSON (no extra text or formatting):
        {
          "title": "...",
          "description": "... (Extend a short info about the recipe. If a diet_type is given, mention why it suits that diet.)",
          "ingredients": [
            { "quantity": "...", "name": "..." },
            ...
          ],
          "steps": [
            { "step": "..." },
            { "step": "..." }
          ]
        }
      PROMPT

      def self.prompt(ingredients, excluded_ingredients = [], diet_type = nil)
        PROMPT_TEMPLATE % {
          ingredients: ingredients,
          excluded_ingredients: excluded_ingredients || "None",
          diet_type: diet_type || "None"
        }
      end
    end
  end
end
