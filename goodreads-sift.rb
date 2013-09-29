# pass in your goodreads csv export file (required)
# and desired shelf (optional) as arguments to this script
#
# e.g. ruby goodreads-sift.rb goodreads_export.csv to-read
#
# you can get your goodreads export file here:
# http://www.goodreads.com/review/import

require 'csv'

books_in_library = {}

CSV.foreach("titles.csv") do |row|
  key = [row[0], row[1]]
  books_in_library[key] = row
end

books = []
File.open(ARGV[0]).readlines.each do |line|
  if line.match(Regexp.new(ARGV[1] || ""))
    # goodreads dumps out csv that ruby can't parse... e.g., ...,="0449912558",="9780449912553"...,
    line.gsub!('="', '"')

    row = CSV.parse_line(line)

    author = row[2]
    title = row[1]

    # goodreads likes to specify which trilogy/etc a books is part of.
    # e.g. The Sparrow (The Sparrow, #1)
    title_without_parenthetical = title.sub(/\s+\(.*?\)$/, '')

    match = books_in_library[[title, author]] || books_in_library[[title_without_parenthetical, author]]

    unless match.nil?
      books << match
      p match
    end
  end
end

if ARGV.include? '--open'
  books.each do |book|
    `open #{book[2]}`
  end
end
