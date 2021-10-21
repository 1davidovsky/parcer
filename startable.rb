# frozen_string_literal: true\

require_relative 'productable'
require_relative 'functionable'

class Category

  def initialize(product_link)
    @product_link = product_link
  end

  include Functions

  def category_urls
    threads = []
    pages_amount.times do |page|
      threads << Thread.new(page) do |urll|
        url = @product_link + "?p=#{page}"
        url = @product_link if page == 1
        get_all_products(url)
      end
    end
    threads.each(&:join)
  end

end

puts 'Ожидайте, идет запись...'
YML = YAML.load(File.read('arguments.yaml'))
product_url = YML['URL']
parser = Category.new(product_url)
parser.category_urls
