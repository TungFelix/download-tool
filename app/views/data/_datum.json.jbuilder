json.extract! datum, :id, :wnid, :category, :source, :downloaded, :path, :created_at, :updated_at
json.url datum_url(datum, format: :json)
