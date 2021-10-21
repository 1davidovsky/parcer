# frozen_string_literal: true
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

  def get_products_data(html)
    html.xpath(YML['PRODUCTS_DATA']).each do |item|
      get_product_info(item.xpath('./@href'))
    end
  end

  def get_product_info(url)
    product_array = []
    html = get_html(url.to_s)
    name = html.xpath(YML['PRODUCTS_NAME']).to_s.strip!
    product_img = html.xpath(YML['PRODUCTS_IMAGE'])
    html.xpath(YML['PRODUCT_ATTRIBUTES_VARIATIONS']).each do |weight|
      full_product_name = "#{name} - #{weight.xpath(YML['PRODUCTS_WEIGHT'])}"
      product_price = weight.xpath(YML['PRODUCTS_PRICE'])
      product.push(Product.new(full_product_name, product_price, product_img))
      Product.save_info(product_array)
    end
  end

  def pages_amount
    html = get_html(CATEGORY_LINK)
    products_on_page = html.xpath(YML['PRODUCTS_DATA']).count
    products_from_all_pages = html.xpath(YML['PRODUCTS_COUNT']).text.to_i
    last_page = (products_from_all_pages / products_on_page).ceil
    last_page.to_i
  end

  def get_all_products(url)
    html = get_html(url)
    get_products_data(html)
  end


end
