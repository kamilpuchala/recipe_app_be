module Api
  module V1
    class RecipesController < ApplicationController
      def create
        Recipes::ValidateIngredients.new(ingredients: recipe_params[:ingredients]).call
      rescue Recipes::Prompts::ValidateIngredients::InvalidInput => e
        render json: {invalid_ingredients: e.message}, status: :unprocessable_entity
      end

      private

      def recipe_params
        params.require(:recipe).permit(ingredients: [])
      end
    end
  end
end
