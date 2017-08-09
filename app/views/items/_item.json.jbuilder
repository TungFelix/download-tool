json.extract! item, :id, :wordnet_id, :file_path, :source_id, :type, :retried_time, :item_status, :created_at, :updated_at
json.url item_url(item, format: :json)
