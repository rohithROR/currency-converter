require 'rails_helper'

RSpec.describe Conversion, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:conversion)).to be_valid
    end
    
    it "is invalid without a source currency" do
      conversion = build(:conversion, source_currency: nil)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:source_currency]).to include("can't be blank")
    end
    
    it "is invalid without a target currency" do
      conversion = build(:conversion, target_currency: nil)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:target_currency]).to include("can't be blank")
    end
    
    it "is invalid without a source amount" do
      conversion = build(:conversion, source_amount: nil)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:source_amount]).to include("can't be blank")
    end
    
    it "is invalid without a target amount" do
      conversion = build(:conversion, target_amount: nil)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:target_amount]).to include("can't be blank")
    end
    
    it "is invalid without a rate" do
      conversion = build(:conversion, rate: nil)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:rate]).to include("can't be blank")
    end
    
    it "is invalid with a negative source amount" do
      conversion = build(:conversion, source_amount: -100)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:source_amount]).to include("must be greater than 0")
    end
    
    it "is invalid with a zero source amount" do
      conversion = build(:conversion, source_amount: 0)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:source_amount]).to include("must be greater than 0")
    end
    
    it "is invalid with a negative target amount" do
      conversion = build(:conversion, target_amount: -85)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:target_amount]).to include("must be greater than 0")
    end
    
    it "is invalid with a zero target amount" do
      conversion = build(:conversion, target_amount: 0)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:target_amount]).to include("must be greater than 0")
    end
    
    it "is invalid with a negative rate" do
      conversion = build(:conversion, rate: -0.85)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:rate]).to include("must be greater than 0")
    end
    
    it "is invalid with a zero rate" do
      conversion = build(:conversion, rate: 0)
      expect(conversion).not_to be_valid
      expect(conversion.errors[:rate]).to include("must be greater than 0")
    end
  end
  
  describe ".recent" do
    before do
      # Create 15 conversions with different timestamps
      15.times do |i|
        create(:conversion, created_at: i.hours.ago)
      end
    end
    
    it "returns the specified number of most recent conversions" do
      recent_conversions = Conversion.recent(5)
      expect(recent_conversions.size).to eq(5)
      expect(recent_conversions.first.created_at).to be > recent_conversions.last.created_at
    end
    
    it "returns all conversions if count is greater than available conversions" do
      recent_conversions = Conversion.recent(20)
      expect(recent_conversions.size).to eq(15)
    end
    
    it "returns empty array when no conversions exist" do
      Conversion.delete_all
      recent_conversions = Conversion.recent(5)
      expect(recent_conversions).to be_empty
    end
  end
end
