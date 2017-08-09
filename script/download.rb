#!/usr/bin/env ruby
require 'open-uri'

def download_image(url, dest)
  open(url) do |u|
    File.open(dest, 'wb') { |f| f.write(u.read) }
  end
  @value_array += [["n11111", dest, 1, 1, 0, 1]]
end

urls = [
  'http://petsfans.com/wp-content/uploads/2014/11/edfsaf.jpg',
  'http://dailynewsdig.com/wp-content/uploads/2012/06/funny-cats.jpg',
  'https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg'
]
dest = '/home/a170424/TrainingData/'
columns = [:wordnet_id, :file_path, :source_id, :item_type, :retried_time, :item_status]

urls.each_slice(1000) do |slice|
  @value_array = []
  slice.each { |url| download_image(url, dest + url.split('/').last) }
  Item.import columns, @value_array
end

def create_session(id, status)
  Session.create (
    source_id: id,
    session_status: status
  	)
end

def create_task(params)
  task_column = [:session_id, :item_id, :task_status]
  task_value = [[session_id, item_id, task_status]]
  Task.import task_column, task_value
end
