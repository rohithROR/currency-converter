require 'rails_helper'
require 'webmock/rspec'

RSpec.describe CurrencyConverterService do
  let(:service) { CurrencyConverterService.new }
  let(:base_url) { CurrencyConverterService::BASE_URL }

  describe '#convert' do
    context 'when source and target currencies are the same' do
      it 'returns the same amount with rate 1.0' do
        result = service.convert('USD', 'USD', 100)
        
        expect(result[:source_currency]).to eq('USD')
        expect(result[:target_currency]).to eq('USD')
        expect(result[:source_amount]).to eq(100)
        expect(result[:target_amount]).to eq(100)
        expect(result[:rate]).to eq(1.0)
      end
    end
    
    context 'when there is a cached rate' do
      before do
        create(:exchange_rate, 
          source_currency: 'USD',
          target_currency: 'EUR',
          rate: 0.85,
          expires_at: 1.hour.from_now
        )
      end
      
      it 'uses the cached rate for conversion' do
        result = service.convert('USD', 'EUR', 100)
        
        expect(result[:source_currency]).to eq('USD')
        expect(result[:target_currency]).to eq('EUR')
        expect(result[:source_amount]).to eq(100)
        expect(result[:target_amount]).to eq(85.0)
        expect(result[:rate]).to eq(0.85)
      end
      
      it 'creates a conversion record' do
        expect {
          service.convert('USD', 'EUR', 100)
        }.to change(Conversion, :count).by(1)
        
        conversion = Conversion.last
        expect(conversion.source_currency).to eq('USD')
        expect(conversion.target_currency).to eq('EUR')
        expect(conversion.source_amount).to eq(100)
        expect(conversion.target_amount).to eq(85.0)
        expect(conversion.rate).to eq(0.85)
      end
    end
    
    context 'when there is no cached rate' do
      before do
        # Use our helper to stub the API
        stub_exchange_rate_api(source_currency: 'USD', target_currency: 'GBP', rate: 0.75)
      end
      
      it 'fetches the rate from the API' do
        result = service.convert('USD', 'GBP', 100)
        
        expect(result[:source_currency]).to eq('USD')
        expect(result[:target_currency]).to eq('GBP')
        expect(result[:source_amount]).to eq(100)
        expect(result[:target_amount]).to eq(75.0)
        expect(result[:rate]).to eq(0.75)
      end
      
      it 'caches the fetched rate' do
        expect {
          service.convert('USD', 'GBP', 100)
        }.to change(ExchangeRate, :count).by(1)
        
        rate = ExchangeRate.last
        expect(rate.source_currency).to eq('USD')
        expect(rate.target_currency).to eq('GBP')
        expect(rate.rate).to eq(0.75)
      end
      
      it 'creates a conversion record' do
        expect {
          service.convert('USD', 'GBP', 100)
        }.to change(Conversion, :count).by(1)
      end
    end
    
    context 'when API request fails' do
      before do
        # Stub a failed API request for an invalid currency
        stub_request(:get, "#{base_url}/USD")
          .to_return(status: 404, body: { result: "error", "error-type": "unsupported-code" }.to_json)
      end
      
      it 'raises an error' do
        expect {
          service.convert('USD', 'XXX', 100)
        }.to raise_error(/Currency not found|Currency pair not supported/)
      end
    end
  end
  
  describe '#get_rate' do
    context 'when source and target currencies are the same' do
      it 'returns 1.0' do
        rate = service.get_rate('USD', 'USD')
        expect(rate).to eq(1.0)
      end
    end
    
    context 'when there is a cached rate' do
      before do
        create(:exchange_rate, 
          source_currency: 'EUR',
          target_currency: 'JPY',
          rate: 130.5,
          expires_at: 1.hour.from_now
        )
      end
      
      it 'returns the cached rate' do
        rate = service.get_rate('EUR', 'JPY')
        expect(rate).to eq(130.5)
      end
    end
    
    context 'when there is no cached rate' do
      before do
        stub_exchange_rate_api(source_currency: 'CAD', target_currency: 'AUD', rate: 1.05)
      end
      
      it 'fetches and returns the rate from the API' do
        rate = service.get_rate('CAD', 'AUD')
        expect(rate).to eq(1.05)
      end
      
      it 'caches the fetched rate' do
        expect {
          service.get_rate('CAD', 'AUD')
        }.to change(ExchangeRate, :count).by(1)
        
        rate = ExchangeRate.last
        expect(rate.source_currency).to eq('CAD')
        expect(rate.target_currency).to eq('AUD')
        expect(rate.rate).to eq(1.05)
      end
    end
  end
  
  describe '#available_currencies' do
    it 'returns a hash of available currencies' do
      currencies = service.available_currencies
      
      # Test for some of the expected currencies
      expect(currencies).to include("USD" => "US Dollar")
      expect(currencies).to include("EUR" => "Euro")
      expect(currencies).to include("GBP" => "British Pound Sterling")
      expect(currencies).to include("JPY" => "Japanese Yen")
      
      # Check that we have at least 30 currencies (the full list)
      expect(currencies.size).to be >= 30
    end
  end
end
