require "rails_helper"

RSpec.describe LlmChats::Groq::ParseResponse do
  let(:response) do
    {
      "choices" => [
        {
          "message" => {
            "content" => '{"key": "value"}'
          }
        }
      ]
    }
  end

  let(:invalid_response) do
    {
      "choices" => []
    }
  end

  let(:parse_response_service) { described_class.new(response: response) }
  let(:invalid_parse_response_service) { described_class.new(response: invalid_response) }

  describe "#parse_to_text" do
    it "returns the content of the first choice message" do
      expect(parse_response_service.parse_to_text).to eq('{"key": "value"}')
    end

    it "raises an error if choices array is empty" do
      expect {
        invalid_parse_response_service.parse_to_text
      }.to raise_error(NoMethodError)
    end
  end

  describe "#parse_to_json" do
    it "parses the content to JSON" do
      expect(parse_response_service.parse_to_json).to eq({"key" => "value"})
    end

    it "raises an error if content is not valid JSON" do
      allow(parse_response_service).to receive(:parse_to_text).and_return("invalid_json")
      expect {
        parse_response_service.parse_to_json
      }.to raise_error(JSON::ParserError)
    end
  end
end
