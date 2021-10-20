# frozen_string_literal: true


require_relative 'module'
require_relative 'yaml_load'

class Parser

  def initialize
    @pages_count = pages_amount
  end

  include Functions

  def category_urls
    threads = []
    @pages_count.times do |page|
      threads << Thread.new(page) do |urll|
        url = CATEGORY_LINK + "?p=#{page}"
        url = CATEGORY_LINK if page == 1
        get_all_products(url)
      end
    end
    threads.each(&:join)
  end

end

puts 'Ожидайте, идет запись...'
parser = Parser.new
parser.category_urls
