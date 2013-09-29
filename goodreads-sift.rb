# pass in your goodreads csv export file (required)
# and desired shelf (optional) as arguments to this script
#
# e.g. ruby goodreads-sift.rb goodreads_export.csv to-read
#
# you can get your goodreads export file here:
# http://www.goodreads.com/review/import

require 'csv'

def titles_match(library_title, goodreads_title)
  library_title.include?(goodreads_title) ||
    goodreads_title.include?(library_title)
end

def authors_match(library_author, goodreads_author)
  library_author.include?(goodreads_author) ||
    goodreads_author.include?(library_author)
end

matching_books = []

goodreads_books = File.open(ARGV[0]).readlines.map do |line|
  if line.match(Regexp.new(ARGV[1] || ""))
    # goodreads dumps out csv that ruby can't parse... e.g., ...,="0449912558",="9780449912553"...,
    line.gsub!('="', '"')

    CSV.parse_line(line.downcase)
  end
end.compact

CSV.read("titles.csv").each do |library_book|
  goodreads_books.each do |goodreads_book|
    if authors_match(library_book[1].downcase, goodreads_book[2]) && titles_match(library_book[0].downcase, goodreads_book[1])
      matching_books << library_book
    end
  end
end


matching_books.sort.each do |book|
  if ARGV.include? '--open'
    `open #{book[2]}`
  end

  p book
end
