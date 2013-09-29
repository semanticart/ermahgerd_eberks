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

you can get your goodreads export file here: http://www.goodreads.com/review/import

you probably want to compare against your to-read shelf

`ruby goodreads-sift.rb goodreads_export.csv to-read`

You can pass `--open` as the last argument to have the script open all the results' reserve pages in your browser.

Note: We're using case-insensitive substring matching for titles and authors. This obviously isn't bullet-proof but should find a lot of matches where goodreads includes a subtitle (or series) and the library does not. Improvements to matching are welcome.


TODO
============

* handle audiobooks separately in both the scrape and the sift.
