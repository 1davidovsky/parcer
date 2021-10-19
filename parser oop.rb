# frozen_string_literal: true

# https://www.petsonic.com/farmacia-para-gatos/

require 'curb'
require 'nokogiri'
require 'csv'
require 'yaml'


module Functions

  YML = YAML.load(File.read('arguments.yaml'))
  CATEGORY_LINK = YML['URL']

  def get_html(url)
    http = Curl.get(url)
    html = Nokogiri::HTML(http.body)
  end

  def save_info(product)
    CSV.open(YML['FILE_NAME'], 'a+') do |csv_file|
      csv_file << %w[Name Price Image] if csv_file.count.zero?
      csv_file << product
    end
  end

  def get_products_data(html)
    html.xpath(YML['PRODUCTS_DATA']).each do |item|
      get_product_info(item.xpath('./@href'))
    end
  end

  def get_product_info(url)
    html = get_html(url.to_s)
    name = html.xpath(YML['PRODUCTS_NAME']).to_s.strip!
    img = html.xpath(YML['PRODUCTS_IMAGE'])
    weight_attr = html.xpath(YML['PRODUCT_ATTRIBUTES_VARIATIONS']).each do |weight|
      name_full = "#{name} - #{weight.xpath(YML['PRODUCTS_WEIGHT'])}"
      price = weight.xpath(YML['PRODUCTS_PRICE'])
      save_info([name_full, price, img])
    end
  end

  def pages_amount
    html = get_html(CATEGORY_LINK)
    per_page = html.xpath(YML['PRODUCTS_DATA']).count
    total = html.xpath(YML['PRODUCTS_COUNT']).text.to_i
    last_page = (total.to_f / per_page).ceil
    last_page.to_i
  end

  def get_all_products(page)
    html = get_html(CATEGORY_LINK)
    get_products_data(html)
  end

  def category_urls
    threads = []
    pages_amount.times do |page|
      threads << Thread.new(page) do |urll|
        url = CATEGORY_LINK + "?p=#{page}"
        url = CATEGORY_LINK if page == 1
        get_all_products(url)
      end
    end
    threads.each(&:join)
  end
end

class Parse

  include Functions

end
puts 'Ожидайте, идет запись продуктов...'
parser = Parse.new
parser.category_urls
