require 'mysql2'
require 'net/ssh/gateway'

def runner
  port = ssh_into_server
  client = mysql_connection(port)

  client.close
end

def mysql_connection(port)
  p "msql"
  ## found in /etc/mysql/debian.cnf
  client = Mysql2::Client.new(
    host: "127.0.0.1",
    username: 'debian-sys-maint',
    password: 'wuxs8WIwxIlGhsLk',
    database: "wordpress",
    port: port
  )
  return client
end

def ssh_into_server
  p 'ssh'
  gateway = Net::SSH::Gateway.new(
    'abrafast.store',
    'root'
  )
  port = gateway.open('127.0.0.1', 3306)
  return port
end

runner