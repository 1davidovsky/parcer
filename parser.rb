# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'csv'

puts 'Введите ссылку:'
link = gets.chomp
http = Curl.get(link)
html = Nokogiri::HTML(http.body)
products_data = html.xpath("//div/div/link[@itemprop='url']/@href")

def save_info(name, weight_all, img, price)
  weight_all.each_with_index do |weight, index|
    CSV.open('test.csv', 'a+') do |csv_file|
      csv_file << %w[Название Цена Вес] if csv_file.count.zero?
      csv_file << ["#{name&.text} - #{weight&.text}", price[index]&.text.to_s, img.to_s]
    end
  end
end

def product(html_body)
  name = html_body.xpath('//h1[@class="product_main_name"]')
  weight_all= html_body.xpath('//span[@class="radio_label"]')
  price = html_body.xpath('//span[@class="price_comb"]')
  img = html_body.xpath('//img[@id="bigpic"]/@src')

  save_info(name, weight_all, img, price)
end

products_data.each do |uri|
  product_link = Curl.get(uri.text)
  product_html = Nokogiri::HTML(product_link.body)
  product(product_html)
end
puts 'Все файлы записаны'
