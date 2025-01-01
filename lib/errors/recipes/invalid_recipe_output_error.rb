module Errors
  module Recipes
    class InvalidRecipeOutputError < StandardError
      def initialize(invalid_ingredients)
        super
      end
    end
  end
end
