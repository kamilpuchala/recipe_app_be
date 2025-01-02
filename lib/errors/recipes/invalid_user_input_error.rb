module Errors
  module Recipes
    class InvalidUserInputError < StandardError
      def initialize(errors)
        super
      end
    end
  end
end
