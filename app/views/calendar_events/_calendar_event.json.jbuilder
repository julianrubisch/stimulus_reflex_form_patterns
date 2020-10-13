json.extract! calendar_event, :id, :occurs_at, :description, :created_at, :updated_at
json.url calendar_event_url(calendar_event, format: :json)
