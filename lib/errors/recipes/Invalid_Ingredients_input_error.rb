module Errors
  module Recipes
    class InvalidIngredientsInputError < StandardError
      def initialize(invalid_ingredients)
        super
      end
    end
  end
end
