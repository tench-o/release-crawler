module Crawler
  class << self
    def crawlers
      Crawler::Base.subclasses
    end

    def get_executor(class_name)
      raise 'not support.' unless class_name =~ /^Crawler/
      Object.const_get(class_name).new
    end

    def all_execute
      results = {}
      crawlers.each do |crawler|
        results[crawler.to_s] = crawler.new.execute
      end

      results
    end

    def target_web_sites
      crawlers.map do |crawler|
        crawler.new.name
      end
    end
  end
end
Dir.glob('./lib/crawler/*.rb') {|f| require f}