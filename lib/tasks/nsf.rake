namespace :nsf do
  
  # bundle exec rake nsf:scrape_grant --trace
  desc "Scrape a grant page"
  task :scrape_grant => :environment do
    
    require "mechanize"
    a = Mechanize.new
    
    doc = a.get("http://www.nsf.gov/awardsearch/showAward?AWD_ID=1124609&HistoricalAwards=false")
    title = doc.search(".//head/title")
    puts "title: #{title.text}"
    
    grant_table = doc.search('.//td[@class="tabletext2"]') #.map{|c| c.text }
    
    
    puts "size of grant_table: #{grant_table.size}"
    puts grant_table
  end

end