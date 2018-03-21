require 'rubygems'
require 'mysql2'
require 'net/http'
require 'uri'

class WindmonController < ApplicationController
layout false
  def wind
#connect to the MYSQL server (27-02-2018)
begin
client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "sql123", :database => "windmon")
rescue Mysql2::Error => e
puts "error"
ensure
#disconnect from server
end


#removing header from http server (27-02-2018)

response.headers.delete('X-Frame-Options')
response.headers.delete('X-XSS-Protection')
response.headers.delete('[truncated]Set-Cookie')
response.headers.delete('X-Request-Id')
response.headers.delete('X-Content-Type-Options')
response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
#parameter passing (27-02-2018)

count=0;
datetime=Time.now.strftime("%Y/%m/%d %H:%M:%S")
@request_type = params[:request_type]
@url =request.url
if @request_type == 'periodic'
@ctrlrid = params[:ctrlrid]
@updated_date = params[:updated_date]
@updated_time = params[:updated_time]
@added_date= Time.now.strftime(" %Y/%m/%d")
@added_time=  Time.now.strftime(" %H:%M:%S")
@uid = params[:uid]
@wtvalue=params[:wtvalue]
@wtvalue_split=@wtvalue.split(',')
@count=0
@wtvalue_split.each do |wtelement|
if(wtelement=='')
@wtvalue_split[@count]='0'
end
@count=@count+1
end
@status = params[:status]
@fault = params[:fault]
@RD_WR_index = params[:RD_WR_index]
@url =request.url

url=URI.parse(request.url)
#http=Net::HTTP.new(uri.host)
http = Net::HTTP.new(url.host, url.port)
http.open_timeout = 0
http.read_timeout = 0
begin
   http.start
   begin
     request = Net::HTTP::Get.new(url)

        response=http.request(request)
      end

   rescue Timeout::Error
      render :text => "timeout due to reading"
end


#xnot_data_tbl insert,update (27-02-2018)

xnot_select_data =client.query("SELECT * FROM xnot_data_tbl WHERE xnot_data_tbl.ctrlrid = #{@ctrlrid} AND request_type='periodic'")

if(xnot_select_data.count==0)

client.query("INSERT INTO xnot_data_tbl VALUES('#{@request_type}','#{@ctrlrid}','#{@updated_date}','#{@updated_time}','#{@added_date}','#{@added_time}','#{@url}')")

else

client.query("UPDATE xnot_data_tbl SET request_type='#{@request_type}',ctrlrid='#{@ctrlrid}' , updated_date=' #{@updated_date}', updated_time = ' #{@updated_time} ', added_date = ' #{@added_date}', added_time = ' #{@added_time}', url = '#{@url}' WHERE ctrlrid='#{@ctrlrid}' AND request_type='periodic' ")

end

periodic_select_data = client.query("SELECT * FROM periodic_data_tbl WHERE periodic_data_tbl.ctrlrid = '#{@ctrlrid}' AND updated_date ='#{@updated_date}' AND updated_time = '#{@updated_time}'")

if (periodic_select_data.count==0)

client.query("INSERT INTO periodic_data_tbl VALUES('#{@request_type}','#{@ctrlrid}','#{@updated_date}','#{@updated_time}','#{@added_date}','#{@added_time}','#{@uid}','#{@wtvalue_split[0]}','#{@wtvalue_split[1]}','#{@wtvalue_split[2]}','#{@wtvalue_split[3]}','#{@wtvalue_split[4]}','#{@wtvalue_split[5]}','#{@wtvalue_split[6]}','#{@wtvalue_split[7]}','#{@wtvalue_split[8]}','#{@wtvalue_split[9]}','#{@wtvalue_split[10]}','#{@wtvalue_split[11]}','#{@wtvalue_split[12]}','#{@wtvalue_split[13]}','#{@wtvalue_split[14]}','#{@wtvalue_split[15]}','#{@wtvalue_split[16]}','#{@wtvalue_split[17]}','#{@wtvalue_split[18]}','#{@wtvalue_split[19]}','#{@wtvalue_split[20]}','#{@status}','#{@fault}','#{@RD_WR_index}', '#{@url}')")

else

client.query("UPDATE periodic_data_tbl SET request_type = '#{@request_type}',ctrlrid = '#{@ctrlrid}',updated_date = '#{@updated_date}',updated_time = '#{@updated_time}',added_date = '#{@added_date}',added_time = '#{@added_time}',uid = '#{@uid}',wtvalue1 = '#{@wtvalue_split[0]}',wtvalue2 = '#{@wtvalue_split[1]}',wtvalue3 = '#{@wtvalue_split[2]}',wtvalue4 = '#{@wtvalue_split[3]}',wtvalue5 = '#{@wtvalue_split[4]}',wtvalue6 = '#{@wtvalue_split[5]}',wtvalue7 = '#{@wtvalue_split[6]}',wtvalue8 = '#{@wtvalue_split[7]}',wtvalue9 = '#{@wtvalue_split[8]}',wtvalue10 = '#{@wtvalue_split[9]}',wtvalue11 = '#{@wtvalue_split[10]}',wtvalue12 = '#{@wtvalue_split[11]}',wtvalue13 = '#{@wtvalue_split[12]}',wtvalue14 = '#{@wtvalue_split[13]}',wtvalue15 = '#{@wtvalue_split[14]}',wtvalue16 = '#{@wtvalue_split[15]}',wtvalue17 = '#{@wtvalue_split[16]}',wtvalue18 = '#{@wtvalue_split[17]}',wtvalue19 = '#{@wtvalue_split[18]}',wtvalue20 = '#{@wtvalue_split[19]}',wtvalue21 = '#{@wtvalue_split[20]}',status1 = '#{@status}',fault = '#{@fault}',RD_WR_index = '#{@RD_WR_index}', url ='#{@url}' WHERE ctrlrid='#{@ctrlrid}' AND updated_time = '#{@updated_time}' AND updated_date = '#{@updated_date}' ")

end
end

#insert update for config (27-02-2018)

if @request_type == 'config'

@request_type = params[:request_type]
@ctrlrid = params[:ctrlrid]
@updated_date = params[:updated_date]
@updated_time = params[:updated_time]
@uid=params[:uid]
  @conval=params[:conval]
  @threshold=params[:threshold]
  @minanalog=params[:minanalog]
  @maxanalog=params[:maxanalog]
  @cause=params[:cause]
  @RD_WR_index=params[:RD_WR_index]
  @PORT_NO=params[:PORT_NO]
  @Ctrl_sel=params[:ctrl_sel]
@added_date = Time.now.strftime("%Y/%m/%d")
@added_time = Time.now.strftime("%H:%M:%S")

render :text => "SERVER_TIME:#{datetime}*RMONRES4 RMONSUCCESS"

xnot_select_data= client.query("SELECT * FROM xnot_data_tbl WHERE xnot_data_tbl.ctrlrid = #{@ctrlrid} AND request_type='config'")

if (xnot_select_data.count==0)

client.query("INSERT INTO xnot_data_tbl VALUES('#{@request_type}','#{@ctrlrid}' , ' #{@updated_date}', ' #{@updated_time} ', ' #{@added_date}', ' #{@added_time}', '#{@url}')  ")

else

client.query("UPDATE xnot_data_tbl SET request_type = '#{@request_type}', ctrlrid='#{@ctrlrid}' , updated_date=' #{@updated_date}', updated_time = ' #{@updated_time} ', added_date = ' #{@added_date}', added_time = ' #{@added_time}', url = '#{@url}' WHERE ctrlrid=#{@ctrlrid} AND request_type='config' ")

end
end

# insert update for check (27-02-2018)

if @request_type == 'check'
@request_type = params[:request_type]
@ctrlrid=params[:ctrlrid]
@updated_date=params[:updated_date]
@updated_time=params[:updated_time]
  @uid=params[:uid]
  @RD_WR_index=params[:RD_WR_index]
@added_date= Time.now.strftime(" %Y/%m/%d")
@added_time=  Time.now.strftime(" %H:%M:%S")

render :text => "SERVER_TIME:#{datetime}*RMONRES3 RMONSUCCESS"

xnot_select_data= client.query("SELECT * FROM xnot_data_tbl WHERE xnot_data_tbl.ctrlrid = #{@ctrlrid} AND request_type='check'")

if (xnot_select_data.count==0)

client.query("INSERT INTO xnot_data_tbl VALUES('#{@request_type}','#{@ctrlrid}' , ' #{@updated_date}', ' #{@updated_time} ', ' #{@added_date}', ' #{@added_time}', '#{@url}')  ")

else

client.query("UPDATE xnot_data_tbl SET request_type = '#{@request_type}', ctrlrid='#{@ctrlrid}' , updated_date=' #{@updated_date}', updated_time = ' #{@updated_time} ', added_date = ' #{@added_date}', added_time = ' #{@added_time}', url = '#{@url}' WHERE ctrlrid=#{@ctrlrid} AND request_type='check' ")


end
end

  end

end
