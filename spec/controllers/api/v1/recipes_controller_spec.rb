require "rails_helper"

RSpec.describe Api::V1::RecipesController, type: :controller do
  describe "POST #create" do
    let(:valid_params) do
      {
        recipe: {
          diet_type: "vegan",
          ingredients: %w[tomato cucumber]
        }
      }
    end

    let(:invalid_ingredients_params) do
      {
        recipe: {
          diet_type: "vegan",
          ingredients: %w[cucumber macbook]
        }
      }
    end

    let(:invalid_diet_type_params) do
      {
        recipe: {
          diet_type: "vegan",
          ingredients: %w[pork sausage]
        }
      }
    end

    it "creates a recipe with valid parameters" do
      VCR.use_cassette("controllers/api/v1/recipes/create/create_recipe_valid") do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["recipe"]).not_to be_nil
      end
    end

    it "returns an error for invalid ingredients" do
      VCR.use_cassette("controllers/api/v1/recipes/create/create_recipe_invalid_ingredients") do
        post :create, params: invalid_ingredients_params
        expect(response).to have_http_status(:unprocessable_entity)

        expect(JSON.parse(response.body)["errors"]).to eq(
          "[\"invalid_ingredient: macbook, this is not an edible product\"]"
        )
      end
    end

    it "returns an error for invalid diet type" do
      VCR.use_cassette("controllers/api/v1/recipes/create/create_recipe_invalid_diet_type") do
        post :create, params: invalid_diet_type_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to eq(
          "[\"invalid_ingredient: sausage explanation why it's invalid: sausage is not a vegan ingredient\"]"
        )
      end
    end
  end
end
