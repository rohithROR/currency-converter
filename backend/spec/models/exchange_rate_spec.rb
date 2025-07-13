require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:exchange_rate)).to be_valid
    end
    
    it "is invalid without a source currency" do
      exchange_rate = build(:exchange_rate, source_currency: nil)
      expect(exchange_rate).not_to be_valid
      expect(exchange_rate.errors[:source_currency]).to include("can't be blank")
    end
    
    it "is invalid without a target currency" do
      exchange_rate = build(:exchange_rate, target_currency: nil)
      expect(exchange_rate).not_to be_valid
      expect(exchange_rate.errors[:target_currency]).to include("can't be blank")
    end
    
    it "is invalid without a rate" do
      exchange_rate = build(:exchange_rate, rate: nil)
      expect(exchange_rate).not_to be_valid
      expect(exchange_rate.errors[:rate]).to include("can't be blank")
    end
    
    it "is invalid without an expiration time" do
      exchange_rate = build(:exchange_rate, expires_at: nil)
      expect(exchange_rate).not_to be_valid
      expect(exchange_rate.errors[:expires_at]).to include("can't be blank")
    end
    
    it "is invalid with a negative rate" do
      exchange_rate = build(:exchange_rate, rate: -0.5)
      expect(exchange_rate).not_to be_valid
      expect(exchange_rate.errors[:rate]).to include("must be greater than 0")
    end
    
    it "is invalid with a rate of zero" do
      exchange_rate = build(:exchange_rate, rate: 0)
      expect(exchange_rate).not_to be_valid
      expect(exchange_rate.errors[:rate]).to include("must be greater than 0")
    end
  end
  
  describe ".find_current_rate" do
    context "when there is a current rate" do
      it "returns the rate if not expired" do
        rate = create(:exchange_rate, 
          source_currency: "USD", 
          target_currency: "EUR", 
          rate: 0.85, 
          expires_at: 1.hour.from_now
        )
        
        found_rate = ExchangeRate.find_current_rate("USD", "EUR")
        expect(found_rate).to eq(rate)
      end
      
      it "returns nil if the rate has expired" do
        create(:exchange_rate, 
          source_currency: "USD", 
          target_currency: "EUR", 
          rate: 0.85, 
          expires_at: 1.hour.ago
        )
        
        found_rate = ExchangeRate.find_current_rate("USD", "EUR")
        expect(found_rate).to be_nil
      end
    end
    
    context "when there is no current rate" do
      it "returns nil" do
        found_rate = ExchangeRate.find_current_rate("USD", "GBP")
        expect(found_rate).to be_nil
      end
    end
  end
  
  describe ".save_rate" do
    context "when creating a new rate" do
      it "creates a new exchange rate record" do
        expect {
          ExchangeRate.save_rate("USD", "JPY", 110.5)
        }.to change(ExchangeRate, :count).by(1)
        
        rate = ExchangeRate.last
        expect(rate.source_currency).to eq("USD")
        expect(rate.target_currency).to eq("JPY")
        expect(rate.rate).to eq(110.5)
        expect(rate.expires_at).to be > Time.current
      end
    end
    
    context "when updating an existing rate" do
      it "updates the existing rate and expiration time" do
        create(:exchange_rate, 
          source_currency: "USD", 
          target_currency: "EUR", 
          rate: 0.85, 
          expires_at: 30.minutes.from_now
        )
        
        expect {
          ExchangeRate.save_rate("USD", "EUR", 0.87)
        }.not_to change(ExchangeRate, :count)
        
        rate = ExchangeRate.find_by(source_currency: "USD", target_currency: "EUR")
        expect(rate.rate).to eq(0.87)
        expect(rate.expires_at).to be > Time.current + 59.minutes
      end
    end
  end
end
