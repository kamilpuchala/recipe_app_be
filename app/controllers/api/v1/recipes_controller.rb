module Api
  module V1
    class RecipesController < ApplicationController
      def create
        Recipes::ValidateIngredients.new(ingredients: recipe_params[:ingredients]).call
        recipe = Recipes::Create.new(ingredients: recipe_params[:ingredients],
          excluded_ingredients: recipe_params[:excluded_ingredients],
          diet_type: recipe_params[:diet_type]).call

        render json: {recipe: recipe}, status: :ok
      rescue Errors::Recipes::InvalidIngredientsInputError,
        Errors::Recipes::InvalidIngredientsInDietTypeScopeError,
        Errors::Recipes::InvalidRecipeOutputError => e

        render json: {errors: e.message}, status: :unprocessable_entity
      end

      private

      def recipe_params
        params.require(:recipe).permit(:diet_type, ingredients: [], excluded_ingredients: [])
      end
    end
  end
end
