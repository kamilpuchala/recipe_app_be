require "rails_helper"

RSpec.describe Recipes::ValidateUserInput do
  describe "#call" do
    let(:valid_ingredients) { %w[tomato cucumber eggs] }
    let(:invalid_ingredients) { %w[cucumber macbook] }
    let(:valid_diet_type_in_ingredients_scope) { "keto" }
    let(:invalid_diet_type_in_ingredients_scope) { "vegan" }

    it "does not raise an error for valid ingredients" do
      VCR.use_cassette("services/recipes/validate_user_input/valid_ingredients") do
        expect { described_class.new(ingredients: valid_ingredients).call }.not_to raise_error
      end
    end

    it "raises an error for invalid ingredients" do
      VCR.use_cassette("services/recipes/validate_user_input/invalid_ingredients") do
        expect {
          described_class.new(ingredients: invalid_ingredients).call
        }.to raise_error do |error|
          expect(error).to be_a(Errors::Recipes::InvalidUserInputError)
          expect(error.message).to eq("[\"invalid_ingredient: macbook It's not a recognized edible grocery product\"]")
        end
      end
    end

    it "does not raise an error for valid diet_type in ingredients scope" do
      VCR.use_cassette("services/recipes/validate_user_input/valid_diet_type_in_ingredients_scope") do
        expect { described_class.new(ingredients: valid_ingredients, diet_type: valid_diet_type_in_ingredients_scope).call }.not_to raise_error
      end
    end

    it "does not raise an error for invalid diet_type in ingredients scope" do
      VCR.use_cassette("services/recipes/validate_user_input/invalid_diet_type_in_ingredients_scope") do
        expect {
          described_class.new(ingredients: valid_ingredients, diet_type: invalid_diet_type_in_ingredients_scope).call
        }.to raise_error do |error|
          expect(error).to be_a(Errors::Recipes::InvalidUserInputError)
          expect(error.message).to eq("[\"invalid_ingredient: chicken explanation why it's invalid\"]")
        end
      end
    end
  end
end
