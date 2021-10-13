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
# CSV.open(file_name, 'wb') do |csv_file|
#   csv_file << %w[Название Цена Изображение]
header = %w[Name Price Image]
CSV.open(file_name, 'a+') do |csv|
  products_url.each do |url|
    current_url = Curl.get(url)
    current_html = Nokogiri::HTML(current_url.body)
    product_name = current_html.xpath('//h1[@class="product_main_name"]')
    product_img = current_html.xpath('//img[@id="bigpic"]/@src')
    product_weight_attribute = current_html.xpath('//span[@class="radio_label"]')
    product_weight_attribute.each do |each_weight|
      product_weight = each_weight
      product_price_attribute = current_html.xpath('//span[@class="price_comb"]')
      product_price_attribute.each do |each_price|
        product_price = each_price
        row = CSV::Row.new(header, [])
        row['Price'] = product_price.text.to_s
        row['Name'] = "#{product_name.text} - #{product_weight.text}"
        row['Image'] = product_img.text.to_s
        csv << row

        # full_info = ["#{product_name.text} - #{product_weight.text}", product_price.text, product_img]
        # puts full_info
        # puts 'Товар записан, идет запись следующего товара...'
        # csv_file << full_info
      end
    end
  end
end

puts 'Все товары записаны в файл записаны!'
