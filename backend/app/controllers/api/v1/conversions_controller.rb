module Api
  module V1
    class ConversionsController < ApplicationController
      # POST /api/v1/convert
      # Converts an amount from source_currency to target_currency
      def convert
        # Validate inputs
        unless params[:source_currency] && params[:target_currency] && params[:amount]
          return render json: { error: 'Missing required parameters' }, status: :unprocessable_entity
        end
        
        amount = params[:amount].to_f
        if amount <= 0
          return render json: { error: 'Amount must be greater than zero' }, status: :bad_request
        end
        
        # Validate currencies are in our supported list
        service = CurrencyConverterService.new
        supported_currencies = service.available_currencies.keys
        
        unless supported_currencies.include?(params[:source_currency].upcase) && supported_currencies.include?(params[:target_currency].upcase)
          return render json: { error: "Unsupported currency. Please use one of: #{supported_currencies.join(', ')}" }, status: :unprocessable_entity
        end
        
        # Perform conversion using service
        begin
          service = CurrencyConverterService.new
          result = service.convert(params[:source_currency].upcase, params[:target_currency].upcase, amount)
          
          render json: result, status: :ok
        rescue => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end
      
      # GET /api/v1/conversions
      # Returns recent conversion history
      def index
        conversions = Conversion.recent(10).map do |conversion|
          {
            id: conversion.id,
            source_currency: conversion.source_currency,
            target_currency: conversion.target_currency,
            source_amount: conversion.source_amount,
            target_amount: conversion.target_amount,
            rate: conversion.rate,
            created_at: conversion.created_at
          }
        end
        
        render json: { conversions: conversions }, status: :ok
      end
    end
  end
end
