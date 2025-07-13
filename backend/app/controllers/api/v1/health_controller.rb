module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: { status: 'ok', timestamp: Time.now.iso8601 }
      end
      
      def debug
        begin
          exchange_rate_url = CurrencyConverterService::BASE_URL
          api_response = HTTParty.get(exchange_rate_url + "/USD")
          
          render json: {
            status: 'ok',
            timestamp: Time.now.iso8601,
            environment: {
              rails_env: Rails.env,
              database_url: ENV['DATABASE_URL'],
              binding: ENV['BINDING']
            },
            api_test: {
              url: exchange_rate_url,
              response_code: api_response.code,
              response_message: api_response.message,
              sample_data: api_response['rates'] ? api_response['rates'].keys.first(3) : nil
            },
            conversions_count: ExchangeRate.count
          }
        rescue => e
          render json: {
            status: 'error',
            error: e.message,
            backtrace: e.backtrace.first(5)
          }, status: 500
        end
      end
    end
  end
end
