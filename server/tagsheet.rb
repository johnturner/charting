#!/usr/bin/env ruby

require 'cgi'
require 'google_spreadsheet'

cgi = CGI.new

if cgi.params["quote"].first and cgi.params["url"].first
  quote = cgi.params["quote"].first
  url = cgi.params["url"].first
  title = nil
  if cgi.params["title"].first
    title = cgi.params["title"]
  end
  
  title ||= url

  session = GoogleSpreadsheet.login "tagsheettest", "tagtagtag"
  key = "thbhW4S-EZNxmaQQeiuTc9A"
  sheet = session.spreadsheet_by_key key
  worksheet = sheet.worksheets.first

  row = worksheet.num_rows + 1
  worksheet[row, 1] = title
  worksheet[row, 2] = url
  worksheet[row, 3] = quote
  worksheet.save
  
  redirect_url = "https://spreadsheets.google.com/ccc?key=#{key}"
  print cgi.header({'Status' => '302 Moved', 'location' => redirect_url})
else
  cgi.out do 
    "Errorz. :("
  end
end

