class CalendarEventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "CalendarEvents"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
