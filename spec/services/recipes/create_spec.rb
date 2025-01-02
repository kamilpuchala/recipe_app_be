require "rails_helper"

RSpec.describe Recipes::Create do
  let(:ingredients) { %w[tomato cucumber] }
  let(:diet_type) { "vegan" }

  subject(:service) do
    described_class.new(
      ingredients: ingredients,
      diet_type: diet_type
    )
  end

  describe "#call" do
    context "when recipe is created successfully" do
      it "creates a correct recipe" do
        VCR.use_cassette("services/recipes/create/create_recipe") do
          expect(subject.call)
            .to eq(
              {
                "title" => "Tomato and Cucumber Salad",
                "description" =>
                  "A refreshing salad perfect for warm days. This recipe is vegan as it doesn't include any animal products.",
                "ingredients" => [
                  {"name" => "tomato", "quantity" => "2"},
                  {"name" => "cucumber", "quantity" => "1"},
                  {"name" => "salt", "quantity" => "1/4 teaspoon"},
                  {"name" => "pepper", "quantity" => "1/4 teaspoon"}
                ],
                "steps" => [
                  {"step" => "Cut the tomatoes and cucumber into small pieces."},
                  {"step" => "Mix the ingredients together in a bowl. Add salt and pepper to taste."}
                ]
              }
            )
        end
      end
    end

    context "when returned recipe is invalid" do
      let(:invalid_recipe) do
        {
          "choices" => [
            {
              "message" => {
                "content" => {
                  "some" => "invalid data"
                }.to_json
              }
            }
          ]
        }
      end

      it "raises an error when create_recipe returns an invalid JSON for the recipe" do
        allow(subject).to receive(:create_recipe).and_return(invalid_recipe)

        VCR.use_cassette("services/recipes/create/validate_ingredients_in_diet_type_scope/recipes_create_validate_recipe_output_invalid") do
          expect { subject.call }
            .to raise_error do |error|
            expect(error).to be_a(Errors::Recipes::InvalidRecipeOutputError)
            expect(error.message).to eq("[\"The response is not in the expected recipe or failure format.\", \"Invalid JSON structure.\"]")
          end
        end
      end
    end
  end
end
