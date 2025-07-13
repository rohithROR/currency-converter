module ApiHelpers
  def stub_exchange_rate_api(source_currency:, target_currency: nil, rate: nil, status: 200)
    # Prepare the response body based on the ExchangeRate API format
    response_body = {
      "result": "success",
      "documentation": "https://www.exchangerate-api.com/docs",
      "terms_of_use": "https://www.exchangerate-api.com/terms",
      "time_last_update_unix": Time.now.to_i,
      "time_last_update_utc": Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S +0000'),
      "time_next_update_unix": (Time.now + 24.hours).to_i,
      "time_next_update_utc": (Time.now + 24.hours).utc.strftime('%a, %d %b %Y %H:%M:%S +0000'),
      "base_code": source_currency,
      "rates": {}
    }
    
    # Add rates if provided
    if target_currency && rate
      response_body[:rates][target_currency] = rate
    else
      # Add some default rates if no specific rate is provided
      default_rates = {
        'USD' => 1.0,
        'EUR' => 0.85,
        'GBP' => 0.75,
        'JPY' => 110.0,
        'AUD' => 1.3,
        'CAD' => 1.25,
        'CHF' => 0.92,
        'CNY' => 6.45,
        'HKD' => 7.78,
        'NZD' => 1.41
      }
      
      # Always include the source currency with rate 1.0
      default_rates[source_currency] = 1.0
      
      response_body[:rates] = default_rates
    end
    
    # Stub the API request
    stub_request(:get, "#{CurrencyConverterService::BASE_URL}/#{source_currency}")
      .to_return(
        status: status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end

RSpec.configure do |config|
  config.include ApiHelpers
end
