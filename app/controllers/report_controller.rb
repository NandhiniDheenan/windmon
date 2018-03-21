class ReportController < ApplicationController
  def showreport
begin
client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "sql123", :database => "windmon")
rescue Mysql2::Error => e
puts "error"
ensure
#disconnect from server
end


 @fromdate = params[:fromdate]
 @todate =params[:todate]
@controllerid =params[:controllerid]

if @fromdate==nil
@fd = Time.now.strftime(" %Y/%m/%d")
 @fromdate = @fd['updated_date']
#@fromdate=Date.parse(fd['updated_date'])..f
end
if @todate==nil
@ld = Time.now.strftime(" %Y/%m/%d")
  @todate = @ld['updated_date']
#@fromdate=Date.parse(fd['updated_date'])..f
end
@periodic_data_tbl =client.query("SELECT  * FROM periodic_data_tbl where ctrlrid='#{@controllerid}'AND updated_date >= '#{@fromdate}' AND updated_date <='#{@todate}' order by updated_date asc")

if (@periodic_data_tbl.count == 0)
@periodic_data_tbl = client.query("SELECT  * FROM periodic_data_tbl order by updated_date desc limit 100")
end
  end
end
