class ExchangeRate < ApplicationRecord
  validates :source_currency, presence: true
  validates :target_currency, presence: true
  validates :rate, presence: true, numericality: { greater_than: 0 }
  validates :expires_at, presence: true
  
  # Find the current rate for a currency pair or return nil if not found/expired
  def self.find_current_rate(source_currency, target_currency)
    where(
      source_currency: source_currency,
      target_currency: target_currency
    ).where("expires_at > ?", Time.current).order(expires_at: :desc).first
  end
  
  # Save a new exchange rate with expiration time of 1 hour or update existing one
  def self.save_rate(source_currency, target_currency, rate)
    existing_rate = where(
      source_currency: source_currency,
      target_currency: target_currency
    ).first
    
    if existing_rate
      existing_rate.update(
        rate: rate,
        expires_at: 1.hour.from_now
      )
      existing_rate
    else
      create(
        source_currency: source_currency,
        target_currency: target_currency,
        rate: rate,
        expires_at: 1.hour.from_now
      )
    end
  end
end
