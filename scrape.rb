require 'open-uri'
require 'csv'
require 'nokogiri'

def parse_page(content)
  Nokogiri::HTML(content).css('.search-results-grid-info').map do |result|
    title = result.css('.trunc-title-line-grid').text
    author = result.css('.trunc-author-line-grid').text
    url = "http://digital.minlib.net/5BCFCE90-489E-4FC4-BB83-F9EE12D1250C/10/50/en/" + result.css('.trunc-title-line-grid a').first['href']

    [title, author, url]
  end
end

catalog_url = "http://digital.minlib.net/5BCFCE90-489E-4FC4-BB83-F9EE12D1250C/10/50/en/SearchResultsGrid.htm?SearchID=14055122s&SortBy=relevancy&Page=%s"

page = 1
max_page = nil

CSV.open("titles.csv", "w") do |csv|
  while max_page.nil? || page < max_page
    puts "page ##{page}"

    content = open(catalog_url % page).read

    if max_page.nil?
      max_page ||= Nokogiri::HTML(content).css('#pageLinks a').last["href"].match(/Page=(\d+)/)[1].to_i
      puts "max page is #{max_page}"
    end

    parse_page(content).each do |result|
      csv << result
    end

    page += 1
  end
end
