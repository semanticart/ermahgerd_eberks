(this repo name intentionally left unfunny)

scrape.rb
============

all you need to scrape the minuteman library digital collection at http://digital.minlib.net/

but you should probably just use the included titles.csv file and leave their server alone :)

titles.csv
============

The results of scrape.rb (sorted by most popular). The final column is the format code. Here's the known codes so far:

* format50: ebooks (adobe pdf only)
* format302: Disney Online Book
* format410: ebooks (not overdrive READ or kindle)
* format420: ebooks (kindle, overdrive READ, adobe epub &/or adobe pdf)
* format425: audiobook
* format450: ebooks (open pdf)
* format610: ebooks (overdrive READ + various formats, but not kindle)
* format810: ebooks (open epub only)
* format@@FORMAT_TYPE_ID@@: ebooks (various formats)

goodreads-sift.rb
============

compare the titles.csv file against your goodreads csv export list to see what's available.

you can get your goodreads export file here: http://www.goodreads.com/review/import

you probably want to compare against your to-read shelf

`ruby goodreads-sift.rb goodreads_export.csv to-read`

You can pass `--open` as the last argument to have the script open all the results' reserve pages in your browser.

Note: We're using case-insensitive substring matching for titles and authors. This obviously isn't bullet-proof but should find a lot of matches where goodreads includes a subtitle (or series) and the library does not. Improvements to matching are welcome.

If you only want certain formats, you can just pipe the output into grep. e.g. for audiobooks

`ruby goodreads-sift.rb goodreads_export.csv to-read | grep format425`
