class WindloginController < ApplicationController
layout false
  def login

begin
client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "sql123", :database => "login")
rescue Mysql2::Error => e
puts "error"
ensure
#disconnect from server
end

@username = params[:username]
@password =params[:password]

@dbuser = client.query("SELECT * FROM userlogin WHERE userlogin.username = '#{@username}' AND userlogin.userpassword = '#{@password}'")

if @dbuser.count==0
puts "try again"
else
redirect_to '/reports'
end

  end
end
