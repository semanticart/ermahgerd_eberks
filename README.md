(this repo name intentionally left unfunny)

scrape.rb
============

all you need to scrape the minuteman library digital collection at http://digital.minlib.net/

but you should probably just use the included titles.csv file and leave their server alone :)

titles.csv
============

the results of scrape.rb (sorted by most popular)

goodreads-sift.rb
============

compare the titles.csv file against your goodreads csv export list to see what's available.

you probably want to compare against your to-read shelf

`ruby goodreads-sift.rb goodreads_export.csv to-read`

Note: this is rather naive, matching on author and title. I've made it slightly more robust by trying titles without the series name, but I'm sure it will still miss matches a human could find.
