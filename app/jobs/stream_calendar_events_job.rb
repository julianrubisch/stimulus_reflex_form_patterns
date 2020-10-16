class StreamCalendarEventsJob < ApplicationJob
  include CableReady::Broadcaster

  queue_as :default

  def perform(dates:, calendar_events:, date_range:)
    cable_ready["CalendarEvents"].morph({
                                          selector: "#calendar-grid",
                                          html: CalendarEventsController.render(partial: 'calendar_events/calendar_grid', locals: {dates: dates, calendar_events: calendar_events, date_range: date_range}),
                                          children_only: true})
    # we also have to reset the form
    cable_ready["CalendarEvents"].inner_html({
                                               selector: "#calendar-form",
                                               html: CalendarEventsController.render(partial: "form", locals: { calendar_event: CalendarEvent.new })})

    cable_ready.broadcast
  end
end
