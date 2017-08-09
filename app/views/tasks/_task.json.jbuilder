json.extract! task, :id, :session_id, :item_id, :task_status, :created_at, :updated_at
json.url task_url(task, format: :json)
