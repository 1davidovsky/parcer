# frozen_string_literal: true


require_relative 'module'
require_relative 'yaml_load'

class Parse

  include Functions

  def initialize(category_url)
    @category_link = category_url
  end

  def category_urls
    threads = []
    pages_amount.times do |page|
      threads << Thread.new(page) do |urll|
        url = @category_link + "?p=#{page}"
        url = @category_link if page == 1
        get_all_products(url)
      end
    end
    threads.each(&:join)
  end

end

puts 'Ожидайте, идет запись...'
category_link = YML['URL']
parser = Parse.new(category_link)
parser.category_urls
