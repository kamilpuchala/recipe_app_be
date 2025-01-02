module Api
  module V1
    class RecipesController < ApplicationController
      def create
        validate_user_input

        recipe = Recipes::Create.new(
          ingredients: recipe_params[:ingredients],
          diet_type: recipe_params[:diet_type]
        ).call

        render json: {recipe: recipe}, status: :ok
      rescue Errors::Recipes::InvalidUserInputError,
        Errors::Recipes::InvalidRecipeOutputError => e

        render json: {errors: e.message}, status: :unprocessable_entity
      end

      private

      def validate_user_input
        Recipes::ValidateUserInput.new(ingredients: recipe_params[:ingredients],
          diet_type: recipe_params[:diet_type]).call
      end

      def recipe_params
        params.require(:recipe).permit(:diet_type, ingredients: [])
      end
    end
  end
end
