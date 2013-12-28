require 'open-uri'
require 'csv'
require 'nokogiri'

delay = [ENV['DELAY'].to_i || 1].min

def parse_page(content)
  Nokogiri::HTML(content).css('.search-result-cover').map do |result|
    title = result.css('.trunc-title-line').text
    author = result.css('.trunc-author-line').text
    url = "http://digital.minlib.net/C29B15FA-BAF1-4A87-9151-46B10B7AF0B5/10/50/en/" + result.css('.trunc-title-line a').first['href']
    fmtid = result.css('.pageturn3-container img').first["data-fmtid"]

    [title, author, url, fmtid]
  end
end



CSV.open("titles.csv", "w") do |csv|
  types = {
    fiction:          '16334872s',
    non_fiction:      '16335001s',
    kids_fiction:     '16335003s',
    audio_fiction:    '16335005s',
    audio_nonfiction: '16335006s'
  }

  types.each do |name, id|
    puts "processing #{name}"

    catalog_url = "http://digital.minlib.net/C29B15FA-BAF1-4A87-9151-46B10B7AF0B5/10/50/en/SearchResults.htm?SearchID=#{id}&SortBy=globalrank&SortOrder=desc&Page=%s"
    page = 1
    max_page = nil

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
end
