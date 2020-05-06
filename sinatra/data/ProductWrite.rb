require 'mysql2'
require 'net/ssh/gateway' #Testing
require './.env.rb'

class ProductWrite
  def self.write(params)
    port = ssh_into_server #Testing
    client = mysql_connection(port)
    url = get_product(params, client)
    client.close
    return url
  end

  def self.get_product (params, client)
    wp_posts_hash = generate_wp_posts_hash(params)
    if get_id(wp_posts_hash, client) != []
      p "its in the database"
      return wp_posts_hash['guid']
    else
      p "creating product"
      create_product(params, wp_posts_hash, client)
      return wp_posts_hash['guid']
    end

  end

  def self.create_product(params, wp_posts_hash, client)
    wp_posts_string = write_sql_string(wp_posts_hash, 'insert', 'wp_posts')
    client.query(wp_posts_string)
    id = get_id(wp_posts_hash, client)
    wp_postmeta_hash = generate_wp_postmeta_hash(params)
    wp_postmeta_headers = ['post_id','meta_key','meta_value']
    wp_postmeta_string = write_sql_multi_rows_string(wp_postmeta_headers, wp_postmeta_hash, 'wp_postmeta', id)
    client.query(wp_postmeta_string)
  end

  def self.get_id(wp_posts_hash, client)
    post_id = client.query("select ID from wp_posts where post_name = '#{wp_posts_hash['post_name']}';")
    post_id.each do |item|
      return item['ID']
    end
  end

  def self.write_sql_multi_rows_string(headers, table_hash, table, id)
    string = "INSERT INTO `#{table}`("
    headers.each do |header|
      string += "`#{header}`,"
    end
    string.delete_suffix!(',')
    string += ") VALUES "
    table_hash.each do |k,v|
      string += "('#{id}','#{k}','#{v}'),"
    end
    string.delete_suffix!(',')
    string += ";"
    return string
  end

  def self.write_sql_string(table_hash, command, table)
    string = "#{command} into `#{table}`("
    table_hash.each do |k,v|
      string += "`#{k}`,"
    end
    string.delete_suffix!(',')
    string += ") VALUES ("
    table_hash.each do |k,v|
      string += "'#{v}',"
    end
    string.delete_suffix!(',')
    string += ");"
    return string
  end

  def self.generate_wp_posts_hash(params)
    hash = {}
    hash['post_author'] = '2'
    hash['post_date'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    hash['post_date_gmt'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    hash['post_content'] = params['description'].gsub("'","\\\\'")
    hash['post_title'] = params['description'].gsub("'","\\\\'")
    hash['post_excerpt'] = nil
    hash['post_status'] = "publish"
    hash['comment_status'] = 'open'
    hash['ping_status'] = 'closed'
    hash['post_password'] = nil
    hash['post_name'] = params['description'].gsub(' - ', '-').gsub("'","").gsub('"',"").gsub('/','-').gsub(" ", "-").downcase
    hash['to_ping'] = nil
    hash['pinged'] = nil
    hash['post_modified'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    hash['post_modified_gmt'] = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    hash['post_content_filtered'] = nil
    hash['post_parent'] = '0'
    hash['guid'] = "https://abrafast.store/product/#{hash['post_name']}/"
    hash['menu_order'] = "0"
    hash['post_type'] = "product"
    hash['post_mime_type'] = nil
    hash['comment_count'] = '0'
    return hash
  end

  def self.generate_wp_postmeta_hash(params)
    hash = {}
    hash['_sku'] = params['sku']
    hash['_regular_price'] = params['cost']
    hash['total_sales'] = "0"
    hash['_tax_status'] = 'taxable'
    hash['_tax_class'] = "''"
    hash['_manage_stock'] = "no"
    hash['_backorders'] = 'no'
    hash['_sold_individually'] = 'no'
    hash['_weight'] = params['weight']
    hash['_virtual'] = 'no'
    hash['_downloadable'] = 'no'
    hash['_download_limit'] = '-1'
    hash['_download_expiry'] = '-1'
    hash['_thumbnail_id'] = '5096'
    hash['_stock'] = 'NULL'
    hash['_stock_status'] = 'instock' 
    hash['_wc_average_rating'] = '0'
    hash['_wc_review_count'] = '0'
    hash['_product_version'] = '4.0.1'
    hash['_price'] = hash['_regular_price']
    hash['_wpm_gtin_code'] = hash['_sku']
    return hash
  end

  def self.mysql_connection(port)
    ## found in /etc/mysql/debian.cnf
    client = Mysql2::Client.new(
      host: "127.0.0.1",
      username: USERNAME,
      password: PASSWORD,
      database: "wordpress",
      port: port
    )
    return client
  end

  def self.ssh_into_server
    gateway = Net::SSH::Gateway.new(
      'abrafast.store',
      'root'
    )
    port = gateway.open('127.0.0.1', 3306)
    return port
  end

    # def self.mysql_connection
    #   ## found in /etc/mysql/debian.cnf
    #   client = Mysql2::Client.new(
    #     host: "127.0.0.1",
    #     username: USERNAME,
    #     password: PASSWORD,
    #     database: "wordpress",
    #   )
    #   return client
    # end
end



