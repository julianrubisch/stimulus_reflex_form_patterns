class CalendarEvent < ApplicationRecord
  validates :description, presence: true
  validates :description, length: {maximum: 240}
  validates :occurs_at, presence: true

  def occurs_at_date
    occurs_at.to_date
  end
end
