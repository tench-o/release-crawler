class Crawler::NagoyaUniv < Crawler::Base
  def enabled?
    false
  end

  def name
    '名古屋大学'
  end

  def index_url
    'http://www.nagoya-u.ac.jp/about-nu/public-relations/researchinfo/'
  end

  def content_list_rule
    '#tabs-3 .info-box'
  end

  def title_rule
    '.title_single a'
  end

  def publish_date_rule
    '.day'
  end

  def content_url_rule
    '.title_single a'
  end

  def content_meta_info
    # PDF形式なので、meta情報は取得しない
    return
  end
end