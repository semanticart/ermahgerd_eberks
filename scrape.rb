require 'open-uri'
require 'csv'
require 'nokogiri'

delay = [ENV['DELAY'].to_i || 1].min

def parse_page(content)
  Nokogiri::HTML(content).css('.search-result-cover').map do |result|
    title = result.css('.trunc-title-line-grid').text
    author = result.css('.trunc-author-line-grid').text
    url = "http://digital.minlib.net/5BCFCE90-489E-4FC4-BB83-F9EE12D1250C/10/50/en/" + result.css('.trunc-title-line-grid a').first['href']
    fmtid = result.css('.pageturn3-container img').first["data-fmtid"]

    [title, author, url, fmtid]
  end
end

catalog_url = "http://digital.minlib.net/5BCFCE90-489E-4FC4-BB83-F9EE12D1250C/10/50/en/SearchResultsGrid.htm?SearchID=14069976s&SortBy=rank&SortOrder=desc&Page=%s"

page = 1
max_page = nil

CSV.open("titles.csv", "w") do |csv|
  while max_page.nil? || page <= max_page
    puts "page ##{page}"

    begin
      content = open(catalog_url % page).read

      if max_page.nil?
        max_page ||= Nokogiri::HTML(content).css('#pageLinks a').last["href"].match(/Page=(\d+)/)[1].to_i
        puts "max page is #{max_page}"
      end

      results = parse_page(content)
    rescue => ex
      p ex
      sleep delay
      puts "retrying"
      retry
    end

    results.each do |result|
      csv << result
    end

    page += 1
    sleep delay
  end
end
