require "rails_helper"

RSpec.describe LlmChats::Groq::Ask do
  let(:client) { instance_double(OpenAI::Client) }
  let(:ask_service) { described_class.new(client: client) }

  let(:valid_params) do
    {
      model: "llama3-8b-8192",
      role: "user",
      content: "Hello",
      temperature: 0.5,
      response_format: "json_object"
    }
  end

  describe "#call" do
    it "calls the client with valid parameters" do
      allow(client).to receive(:chat)

      ask_service.call(**valid_params)

      expect(client).to have_received(:chat).with(
        parameters: {
          model: "llama3-8b-8192",
          response_format: {type: "json_object"},
          messages: [
            {
              role: "user",
              content: "Hello"
            }
          ],
          temperature: 0.5
        }
      )
    end

    it "raises an error for invalid role" do
      expect {
        ask_service.call(**valid_params.merge(role: "invalid_role"))
      }.to raise_error(ArgumentError, "Invalid role")
    end

    it "raises an error for invalid content" do
      expect {
        ask_service.call(**valid_params.merge(content: ""))
      }.to raise_error(ArgumentError, "Invalid content")
    end
  end

  describe "#valid_role" do
    it "returns the role if valid" do
      expect(ask_service.send(:valid_role, "user")).to eq("user")
    end

    it "raises an error if role is invalid" do
      expect {
        ask_service.send(:valid_role, "invalid_role")
      }.to raise_error(ArgumentError, "Invalid role")
    end
  end

  describe "#valid_content" do
    it "returns the content if valid" do
      expect(ask_service.send(:valid_content, "Hello")).to eq("Hello")
    end

    it "raises an error if content is invalid" do
      expect {
        ask_service.send(:valid_content, "")
      }.to raise_error(ArgumentError, "Invalid content")
    end
  end

  describe "#valid_temperature" do
    it "returns the temperature if valid" do
      expect(ask_service.send(:valid_temperature, 0.5)).to eq(0.5)
    end

    it "raises an error if temperature is invalid" do
      expect {
        ask_service.send(:valid_temperature, 1.5)
      }.to raise_error(ArgumentError, "Invalid temperature")
    end
  end
end
