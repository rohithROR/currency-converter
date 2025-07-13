module ApiHelpers
  def stub_exchange_rate_api(source_currency:, target_currency: nil, rate: nil, status: 200)
    # Prepare the response body based on the Frankfurter API format
    date = Date.today.to_s
    response_body = {
      "amount": 1,
      "base": source_currency,
      "date": date,
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
    
    # Stub the API request for Frankfurter format
    if target_currency && rate
      # Stub specific currency pair request
      stub_request(:get, "#{CurrencyConverterService::BASE_URL}/latest?from=#{source_currency}&to=#{target_currency}")
        .to_return(
          status: status,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    else
      # Stub general request for all rates
      stub_request(:get, "#{CurrencyConverterService::BASE_URL}/latest?from=#{source_currency}")
        .to_return(
          status: status,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end
  end
end

RSpec.configure do |config|
  config.include ApiHelpers
end
