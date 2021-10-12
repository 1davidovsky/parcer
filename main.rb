# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'csv'
url = Curl.get('https://www.petsonic.com/farmacia-para-gatos/')
html = Nokogiri::HTML(url.body)
products_url = html.xpath("//div/div/link[@itemprop='url']/@href")
print 'Введите имя файла:'
file_name = "#{gets.chomp}.csv"
puts 'Подождите, идет запись товаров...'
counter = 1
CSV.open(file_name, 'wb') do |csv_file|
  csv_file << %w[Название Цена Изображение]
  counter += 1
  products_url.each do |url|
    current_url = Curl.get(url)
    current_html = Nokogiri::HTML(current_url.body)
    product_name = current_html.xpath('//h1[@class="product_main_name"]')
    product_img = current_html.xpath('//img[@id="bigpic"]/@src')
    product_weight_attribute = current_html.xpath('//span[@class="radio_label"]')
    product_weight_attribute.each do |each_weight|
      product_weight = each_weight
      product_price_attribute = each_weight.xpath('//span[@class="price_comb"]')
      product_price_attribute.each do |each_price|
        product_price = each_price
        full_info = ["#{product_name.text} - #{product_weight.text}", product_price.text, product_img]
        puts full_info
        puts "#{counter} товар записан, идет запись следующего товара..."
        counter += 1
        csv_file << full_info
      end
    end
  end
end

puts 'Все товары записаны в файл записаны!'
