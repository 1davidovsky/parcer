# frozen_string_literal: true

# https://www.petsonic.com/farmacia-para-gatos/

require 'curb'
require 'nokogiri'
require 'csv'
require 'yaml'

YML = YAML.load(File.read('argument.yaml'))
@category_link = 'https://www.petsonic.com/farmacia-para-gatos/'
puts @category_link


def get_html(url)
  http = Curl.get(url)
  html = Nokogiri::HTML(http.body)
end

def save_info(product)
  CSV.open('i_am_dead.csv', 'a+') do |csv_file|
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
  name = html.xpath(YML['PRODUCT_NAME']).to_s.strip!
  img = html.xpath(YML['PRODUCT_IMAGE'])
  weight_attr = html.xpath(YML['PRODUCT_ATTRIBUTES_VARIATIONS'])
  processing_product_info(name, img, weight_attr)
end

def processing_product_info(name, img, weight_attr)
  weight_attr.each do |weight|
    name_full = "#{name} - #{weight.xpath(YML['PRODUCT_WEIGHT_ALL'])}"
    price = weight.xpath(YML['PRODUCT_PRICE_ALL'])
    save_info([name_full, price, img])
  end
end

def pages_amount
  html = get_html(@category_link)
  per_page = html.xpath(YML['PRODUCTS_DATA']).count
  total = html.xpath(YML['PRODUCTS_COUNT']).text.to_i
  last_page = (total.to_f / per_page).ceil
  last_page.to_i
end

def get_all_products(page)
  html = get_html(@category_link)
  get_products_data(html)
end

def pages_counter
  pages_amount.times do |page|
    puts "Запись со страницы №#{page + 1}"
    get_all_products(page)
  end
end

pages_counter
# frozen_string_literal: true

# https://www.petsonic.com/farmacia-para-gatos/

# require 'curb'
# require 'nokogiri'
# require 'csv'
#
# @category_link = 'https://www.petsonic.com/farmacia-para-gatos/'
#
# def get_html(url)
#   http = Curl.get(url)
#   html = Nokogiri::HTML(http.body)
# end
#
# def save_info(product)
#   CSV.open('never_end.csv', 'a+') do |csv_file|
#     csv_file << %w[Name Price Image] if csv_file.count.zero?
#     csv_file << product
#   end
# end
#
# def get_products_data(html)
#   html.xpath("//ul[@id='product_list']//a[@class='product-name']").each do |item|
#     products(item.xpath('./@href'))
#   end
# end
#
# def products(url)
#   html = get_html(url.to_s)
#   name = html.xpath("//h1[@class='product_main_name']/text()").to_s.strip!
#   img = html.xpath("//img[@id='bigpic']/@src")
#   weight_attr = html.xpath("//div[@class='attribute_list']/ul/li")
#   condition(name, img, weight_attr)
# end
#
# def condition(name, img, weight_attr)
#   weight_attr.each do |weight|
#     name_full = "#{name} - #{weight.xpath("./label/span[@class='radio_label']/text()")}"
#     price = weight.xpath("./label/span[@class='price_comb']/text()")
#     save_info([name_full, price, img])
#   end
# end
#
#
#
# puts 'Запись началась, ожидайте...'
# def page_counter
#   html = get_html(@category_link)
#   per_page = html.xpath("//ul[@id='product_list']//a[@class='product-name']").count
#   total = html.xpath("//input[@name = 'n']/@value").text.to_i
#   last_page = (total.to_f / per_page).ceil
#   last_page.to_i
# end
#
# def get_all_products(page)
#   html = get_html(@category_link)
#   get_products_data(html)
# end
#
# puts 'Запись со страницы №1'
# page_counter.times do |page|
#   puts "Запись со страницы №#{page + 2}"
#   get_all_products(page)
# end