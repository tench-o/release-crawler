require 'mechanize'
require 'uri'

module Crawler
  class Base
    def self.subclasses
      ObjectSpace.each_object(Class).select {|klass| klass.superclass == self}
    end

    def execute
      begin
        #return [] unless enabled?
        page = client.get(index_url)
        content_list = page.search(content_list_rule)

        @results = []
        content_list.each do |content|
          elem = {}
          elem[:title] = parse_title(content)
          elem[:publish_date] = parse_publish_date(content)
          elem[:content_url] = parse_content_url(content)

          @results << elem
        end
      rescue => e
        puts name
        puts e
      end

      @results
    end

    def parse_title(content)
      content.search(title_rule).text
    end

    def parse_publish_date(content)
      d = content.search(publish_date_rule).text
      d.gsub!(/[年月]/, '-')

      begin
        d = Date.parse(d) if d
      rescue
      end

      d
    end

    def parse_content_url(content)
      content_url = content.search(content_url_rule).attr('href').text
      # 相対パスで始まっていれば、URLを組み立てておく
      if content_url !~ /^http/
        uri = URI.parse(index_url)
        content_url = uri.merge(content_url).to_s
      end

      content_url
    end

    def enabled?
      true
    end

    def name
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def index_url
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def content_list_rule
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def title_rule
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def publish_date_rule
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def content_url_rule
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def client
      @agent ||= Mechanize.new
      @agent.user_agent_alias = 'Windows Mozilla'
      @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      #@agent.ssl_version = 'TLSv1'
      @agent
    end
  end
end