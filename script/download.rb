#!/usr/bin/env ruby
require 'open-uri'
require 'optparse'

def download_image(url, params)
  begin
  	file_path = params[:folder] + "/" + url.split('/').last
    open(url) do |u|
      File.open(file_path, 'wb') { |f| f.write(u.read) }
    end
  rescue
  	@retry_times += 1
  	if @retry_times < 4
  	  puts "Retry to download item: #{params[:wordnet_id]}"
  	  retry
  	end
  	puts "File #{params[:wordnet_id]} not found"
  	@fail_count += 1
  	return
  end
  
  @value_array += [[params[:wordnet_id], file_path, params[:source_id], params[:item_type], @retry_times, 1]]
  @success_count += 1
  #Task.create! session_id: session.id, item_id: 0, task_status: 1
end

def start(params)
  session = Session.create! source_id: params[:source_id], session_status: 1
  @success_count = 0
  @fail_count = 0
  urls = [
    'http://petsfans.com/wp-content/uploads/2014/11/edfsaf.jpg',
    'http://dailnewsdig.com/wp-content/uploads/2012/06/funny-cats.jpg',
    'https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg'
  ]
  #file_path = '/home/a170424/TrainingData/'
  columns = [:wordnet_id, :file_path, :source_id, :item_type, :retried_time, :item_status]  

  urls.each_slice(1000) do |slice|
    @value_array = []
    slice.each do |url|
      @retry_times = 0
      download_image(url, params)
    end
    Item.import columns, @value_array
    p "Downloaded items: #{@success_count}"
    p "Fail items: #{@fail_count}"
  end
end

#-----------------------------------------------------------------------------------------

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: opt_parser COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     start: start download"
  opt.separator  "     stop: stop download"
  opt.separator  "     restart: restart download"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("--folder PATH","where you save data") do |s|
  	options[:folder] = s
  end

  opt.on("--source N","download from: 1 - Imagenet, 2 - MSCoCo") do |n|
    options[:source_id] = n
  end

  opt.on("--url LINK","link download") do |s|
  	options[:urls] = s
  end

  opt.on("--wordnetid ID","which wordnet_id you want to download") do |s|
    options[:wordnet_id] = s
  end

  opt.on("--type N", Integer, "data type") do |n|
    options[:item_type] = n
  end

  opt.on("--retry","retry download") do
    options[:retry] = true
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!


case ARGV[0]
when "start"
  puts "start download from #{options.inspect}"
  start(options)
when "stop"
  puts "stop download"
when "restart"
  puts "restart download on options #{options.inspect}"
  
else
  puts opt_parser
end
