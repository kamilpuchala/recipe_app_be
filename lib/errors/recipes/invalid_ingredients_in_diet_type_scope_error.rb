module Errors
  module Recipes
    class InvalidIngredientsInDietTypeScopeError < StandardError
      def initialize(reasons)
        super
      end
    end
  end
end
