require 'httparty'

class CurrencyConverterService
  # Using Frankfurter API as specified in requirements
  BASE_URL = 'https://api.frankfurter.app'.freeze
  
  def initialize
    # Nothing needed for initialization
  end
  
  # Converts an amount from source_currency to target_currency
  # Uses cached rate if available, otherwise fetches from Frankfurter API
  def convert(source_currency, target_currency, amount)
    rate = get_rate(source_currency, target_currency)
    target_amount = amount * rate
    
    # Store the conversion in database
    conversion = Conversion.create!(
      source_currency: source_currency,
      target_currency: target_currency,
      source_amount: amount,
      target_amount: target_amount,
      rate: rate
    )
    
    {
      source_currency: source_currency,
      target_currency: target_currency,
      source_amount: amount,
      target_amount: target_amount,
      rate: rate,
      rate_timestamp: conversion.created_at
    }
  end
  
  # Gets the exchange rate for a currency pair
  # Uses cached rate if available, otherwise fetches from Frankfurter API
  def get_rate(source_currency, target_currency)
    # Return 1.0 if source and target currencies are the same
    return 1.0 if source_currency == target_currency
    
    # Check if we have a current cached rate
    cached_rate = ExchangeRate.find_current_rate(source_currency, target_currency)
    return cached_rate.rate if cached_rate
    
    # If not cached or expired, fetch from Frankfurter API
    begin
      # Frankfurter requires a different endpoint format: /latest?from=SOURCE&to=TARGET
      api_response = HTTParty.get("#{BASE_URL}/latest?from=#{source_currency}&to=#{target_currency}")
      
      if api_response.success?
        # Check if the target currency is in the response
        if api_response['rates'] && !api_response['rates'][target_currency].nil?
          rate = api_response['rates'][target_currency].to_f
          
          # Cache the rate for 1 hour
          ExchangeRate.save_rate(source_currency, target_currency, rate)
          
          return rate
        else
          raise "Currency pair not supported: #{source_currency} to #{target_currency}"
        end
      else
        # Handle specific error codes
        case api_response.code
        when 404
          raise "Currency not found: #{source_currency} is not supported"
        else
          raise "Failed to fetch exchange rate: #{api_response.code} - #{api_response.message}"
        end
      end
    rescue => e
      # Log the error and re-raise
      Rails.logger.error("Exchange rate API error: #{e.message}")
      raise e
    end
  end
  
  # Returns the list of available currencies from Frankfurter API
  def available_currencies
    # Frankfurter API supports these currencies
    {
      'AUD' => 'Australian Dollar',
      'BGN' => 'Bulgarian Lev',
      'BRL' => 'Brazilian Real',
      'CAD' => 'Canadian Dollar',
      'CHF' => 'Swiss Franc',
      'CNY' => 'Chinese Yuan',
      'CZK' => 'Czech Republic Koruna',
      'DKK' => 'Danish Krone',
      'EUR' => 'Euro',
      'GBP' => 'British Pound Sterling',
      'HKD' => 'Hong Kong Dollar',
      'HUF' => 'Hungarian Forint',
      'IDR' => 'Indonesian Rupiah',
      'ILS' => 'Israeli New Sheqel',
      'INR' => 'Indian Rupee',
      'ISK' => 'Icelandic Króna',
      'JPY' => 'Japanese Yen',
      'KRW' => 'South Korean Won',
      'MXN' => 'Mexican Peso',
      'MYR' => 'Malaysian Ringgit',
      'NOK' => 'Norwegian Krone',
      'NZD' => 'New Zealand Dollar',
      'PHP' => 'Philippine Peso',
      'PLN' => 'Polish Zloty',
      'RON' => 'Romanian Leu',
      'SEK' => 'Swedish Krona',
      'SGD' => 'Singapore Dollar',
      'THB' => 'Thai Baht',
      'TRY' => 'Turkish Lira',
      'USD' => 'US Dollar',
      'ZAR' => 'South African Rand'
    }
  end
end
