# frozen_string_literal: true

module Recipes
  module Prompts
    class ValidateRecipeOutput
      PROMPT_TEMPLATE = <<~PROMPT
        You are a strict validator of the following LLM output:

        %{llm_output}

        The valid output must be in **pure JSON** with EXACTLY one of these formats:

        1) **Failure format** (if the recipe can't be built or an error occurred):
        {
          "fail": "Short explanation"
        }


        **Validation Rules**:
        - The response must be valid JSON (no extra text, no markdown).
        - If it's the recipe format, all keys (title, description, ingredients, steps) HAVE TO be present.
          - "ingredients" must be an array of objects, each with "quantity" and "name".
          - "steps" must be an array of objects, each with "step".
        - If it's the failure format, ONLY the "fail" key with a short explanation string is allowed.
        - No extra keys are allowed in either format.
        - Any other structure or missing fields is invalid.

        Now, **strictly** check if the above LLM output is valid or not. Return ONLY one of these two JSON objects:

        1. If the LLM output is fully valid:
        {
          "valid": true
        }

        2. If the LLM output is invalid (not JSON, missing fields, extra keys, or nonsense):
        {
          "valid": false,
          "reasons": [
            "reason explaining what went wrong",
            ...
          ]
        }

        No extra text or formatting—return ONLY one of these two JSON objects.
      PROMPT

      def self.prompt(llm_output)
        PROMPT_TEMPLATE % {llm_output: llm_output}
      end
    end
  end
end
