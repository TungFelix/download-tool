json.extract! session, :id, :source_id, :session_status, :created_at, :updated_at
json.url session_url(session, format: :json)
