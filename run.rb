require './lib/crawler'
require 'csv'

results = Crawler.all_execute

puts %w(サイト名 記事タイトル 公開日 記事URL).to_csv
results.each do |crawler, articles|
  next if articles.nil?
  klass = Crawler.get_executor(crawler)
  articles.each do |article|
    puts [klass.name, article[:title], article[:publish_date], article[:content_url]].to_csv
  end
end