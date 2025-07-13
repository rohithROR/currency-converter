require 'rails_helper'

RSpec.describe Api::V1::ConversionsController, type: :controller do
  describe "POST #convert" do
    let(:valid_params) do
      { 
        source_currency: "USD", 
        target_currency: "EUR", 
        amount: 100 
      }
    end
    
    context "with valid parameters" do
      before do
        allow_any_instance_of(CurrencyConverterService).to receive(:convert).and_return({
          source_currency: "USD",
          target_currency: "EUR",
          source_amount: 100,
          target_amount: 85,
          rate: 0.85,
          rate_timestamp: Time.current
        })
      end
      
      it "returns a successful response" do
        post :convert, params: valid_params
        expect(response).to have_http_status(:ok)
      end
      
      it "returns the conversion result" do
        post :convert, params: valid_params
        json_response = JSON.parse(response.body)
        
        expect(json_response["source_currency"]).to eq("USD")
        expect(json_response["target_currency"]).to eq("EUR")
        expect(json_response["source_amount"]).to eq(100)
        expect(json_response["target_amount"]).to eq(85)
        expect(json_response["rate"]).to eq(0.85)
      end
    end
    
    context "with invalid amount" do
      it "returns a bad request status" do
        post :convert, params: { source_currency: "USD", target_currency: "EUR", amount: 0 }
        expect(response).to have_http_status(:bad_request)
      end
      
      it "returns an error message" do
        post :convert, params: { source_currency: "USD", target_currency: "EUR", amount: 0 }
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to include("Amount must be greater than zero")
      end
    end
    
    context "when conversion service raises an error" do
      before do
        allow_any_instance_of(CurrencyConverterService).to receive(:convert).and_raise("Invalid currency code")
      end
      
      it "returns an unprocessable entity status" do
        post :convert, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "returns an error message" do
        post :convert, params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid currency code")
      end
    end
  end
  
  describe "GET #index" do
    before do
      create_list(:conversion, 5)
    end
    
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:ok)
    end
    
    it "returns the list of recent conversions" do
      get :index
      json_response = JSON.parse(response.body)
      
      expect(json_response["conversions"]).to be_an(Array)
      expect(json_response["conversions"].length).to eq(5)
      expect(json_response["conversions"].first).to include(
        "source_currency", 
        "target_currency", 
        "source_amount", 
        "target_amount", 
        "rate"
      )
    end
    
    it "returns conversions in descending order by creation time" do
      # Create a newer conversion
      newest = create(:conversion, created_at: 1.minute.from_now)
      
      get :index
      json_response = JSON.parse(response.body)
      
      expect(json_response["conversions"].first["id"]).to eq(newest.id)
    end
  end
end
