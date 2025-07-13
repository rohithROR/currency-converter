# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
ExchangeRate.destroy_all
Conversion.destroy_all

puts "Seeding sample exchange rates..."

# Create some sample exchange rates
exchange_rates = [
  { source_currency: 'USD', target_currency: 'EUR', rate: 0.85, expires_at: 1.hour.from_now },
  { source_currency: 'USD', target_currency: 'GBP', rate: 0.75, expires_at: 1.hour.from_now },
  { source_currency: 'USD', target_currency: 'JPY', rate: 110.5, expires_at: 1.hour.from_now },
  { source_currency: 'EUR', target_currency: 'USD', rate: 1.18, expires_at: 1.hour.from_now },
  { source_currency: 'GBP', target_currency: 'USD', rate: 1.33, expires_at: 1.hour.from_now },
]

ExchangeRate.create!(exchange_rates)

puts "Seeding sample conversion history..."

# Create some sample conversion history
conversions = [
  { source_currency: 'USD', target_currency: 'EUR', source_amount: 100, target_amount: 85, rate: 0.85, created_at: 2.days.ago },
  { source_currency: 'EUR', target_currency: 'USD', source_amount: 50, target_amount: 59, rate: 1.18, created_at: 1.day.ago },
  { source_currency: 'USD', target_currency: 'GBP', source_amount: 200, target_amount: 150, rate: 0.75, created_at: 12.hours.ago },
  { source_currency: 'GBP', target_currency: 'USD', source_amount: 75, target_amount: 99.75, rate: 1.33, created_at: 6.hours.ago },
  { source_currency: 'USD', target_currency: 'JPY', source_amount: 50, target_amount: 5525, rate: 110.5, created_at: 2.hours.ago },
]

Conversion.create!(conversions)

puts "Seeding completed successfully!"
