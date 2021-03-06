require 'mysql2'
require 'pry'

class Adapter
  

  def showtime
    puts 'showtime'
  end

  def insert_query(hash_data = {})
    wordnet_id = @client.escape(hash_data[:wordnet_id])
    file_path = @client.escape(hash_data[:file_path])
    source_id = @client.escape(hash_data[:source_id])
    type = @client.escape(hash_data[:type])
    retried_time = @client.escape(hash_data[:retried_time])
    item_status = @client.escape(hash_data[:item_status])
    @client.query("INSERT INTO #{hash_data[:table]} (wordnet_id, file_path, source_id, type, retried_time, item_status, created_at, updated_at)
                   VALUES
                     (
                      '#{wordnet_id}',
                      '#{file_path}',
                      '#{source_id}',
                      '#{type}',
                      '#{retried_time}',
                      '#{item_status}',
                      '#{hash_data[:created_at]}',
                      '#{hash_data[:updated_at]}'
                     )")
  end

  def check_duplicate(table, origin_url)
    res = @client.query("SELECT id FROM #{table} WHERE origin_url='#{origin_url}'")
    res.count > 0 ? true : nil
  end

  def get_post(table)
    res = @client.query("SELECT id,translate_title,text,image_url,origin_title FROM #{table} WHERE is_published='0' LIMIT 2")
    return_res(res)
  end

  def get_post_by_keyword(table, *args)
    query_arr = []
    query_arr << "SELECT id,translate_title,text,image_url,origin_title FROM #{table}"
    query_arr << "WHERE ("
    i = 1
    args.each do |keyword|
      case i
        when 1
          query_arr << "origin_title LIKE '%#{keyword.strip}%' OR text LIKE '%#{keyword.strip}%' OR"
          query_arr << "origin_title LIKE '%#{keyword.strip}%' OR text LIKE '%#{keyword.strip}%'" if i == args.count
        when args.length
          query_arr << "origin_title LIKE '%#{keyword.strip}%' OR text LIKE '%#{keyword.strip}%'"
        else
          query_arr << "origin_title LIKE '%#{keyword.strip}%' OR text LIKE '%#{keyword.strip}%' OR"
        end
      i += 1
    end
    query_arr << ") AND is_published='0' LIMIT 1"
    res = @client.query(query_arr.join(' '))
    return_res(res)
  end

  def get_post_by_id(table, id)
    @client.query("SELECT * FROM #{table} WHERE id='#{id}'")
  end

  def update_is_publish(table, id)
    @client.query("UPDATE #{table} SET is_published='1',updated_at='#{Time.now}' WHERE id='#{id}'")
  end

  def update_picture_url(image_url, table, id)
    @client.query("UPDATE #{table} SET image_url='#{image_url}',updated_at='#{Time.now}' WHERE id='#{id}'")
  end

  def load_all_id_title(conditon, table)
    @client.query("SELECT id,origin_title FROM #{table} #{conditon}")
  end

  def load_fixer(table)
    @client.query("SELECT id,text FROM #{table} WHERE text LIKE '%source_url%' AND is_published='0' LIMIT 100")
  end

  def load_all_db(table)
    @client.query("SELECT * FROM #{table}")
  end

  def update_fixer(text, table, id)
    text_hash = @client.escape(text)
    @client.query("UPDATE #{table} SET text='#{text_hash}',updated_at='#{Time.now}' WHERE id='#{id}'")
  end

  def return_res(res)
    if res.count.zero?
      nil
    else
      res.first
    end
  end
end
