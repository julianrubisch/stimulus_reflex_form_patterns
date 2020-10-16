# frozen_string_literal: true

class SettingsReflex < ApplicationReflex
  include Submittable

  before_reflex :fetch_dates 

  after_reflex do
    @calendar_events = CalendarEvent.where(occurs_at: @date_range).order(:occurs_at).group_by(&:occurs_at_date)
    StreamCalendarEventsJob.perform_now(dates: @dates, calendar_events: @calendar_events, date_range: @date_range)
  end

  private

  def submit_params
    params.require(:setting).permit(:holiday_region)
  end

  def fetch_dates
    @start_date = Date.current.to_date.beginning_of_month
    @date_range = (@start_date..@start_date.end_of_month)
    @dates = @date_range.to_a
    @dates.prepend(@dates.first - 1) until @dates.first.sunday?
    @dates.append(@dates.last + 1) until @dates.last.saturday?
  end
end
