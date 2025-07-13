class Conversion < ApplicationRecord
  validates :source_currency, presence: true
  validates :target_currency, presence: true
  validates :source_amount, presence: true, numericality: { greater_than: 0 }
  validates :target_amount, presence: true, numericality: { greater_than: 0 }
  validates :rate, presence: true, numericality: { greater_than: 0 }
  
  # Returns the most recent conversions, ordered by created_at desc
  def self.recent(limit = 10)
    order(created_at: :desc).limit(limit)
  end
end
