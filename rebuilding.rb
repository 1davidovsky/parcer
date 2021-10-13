# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'csv'

url = Curl.get('https://www.petsonic.com/farmacia-para-gatos/')
html = Nokogiri::HTML(url.body)
products_url = html.xpath("//div/div/link[@itemprop='url']/@href")

puts 'Подождите, идет запись товаров...'
products_url.each do |url|
  current_url = Curl.get(url)
  current_html = Nokogiri::HTML(current_url.body)
  product_name = current_html.xpath('//h1[@class="product_main_name"]')
  product_img = current_html.xpath('//img[@id="bigpic"]/@src')
  product_weight_attribute = current_html.xpath('//span[@class="radio_label"]')
  product_weight_attribute.each do |weight|
    product_weight = weight
    product_price_attribute = weight.xpath('//span[@class="price_comb"]')
    product_price_attribute.each do |price|
      product_price = price
      full_info = ["#{product_name.text} - #{product_weight.text}", product_price.text, product_img]
      puts full_info
      puts 'Товар записан, идет запись следующего товара...'
    end
  end
end

def save_information(product_name, product_weight, product_img, product_price)
  File.open(file_name, 'a') do |csv_file|
    csv_file << %w[Название Изображение Цена Вес] if csv_file.count.zero?
    csv_file << ["#{product_name.text} - #{product_weight.text}", product_img.text, product_price.text]
  end
end


# print 'Введите имя файла:'
# file_name = "#{gets.chomp}.csv"

puts 'Все товары записаны в файл записаны!'

