# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'csv'

puts 'Введите ссылку:'
link = gets.chomp
url = Curl.get(link)
html = Nokogiri::HTML(url.body)
products_url = html.xpath("//div/div/link[@itemprop='url']/@href")

def save_info(name, weight, img, price)
  weight.each_with_index do |w,index |
    CSV.open('test.csv', 'a+') do |csv_file|
      csv_file << %w[Название Цена Вес] if csv_file.count.zero?
      csv_file << ["#{name&.text} - #{w&.text}", price[index]&.text.to_s, img.to_s]
      puts ["#{name&.text} - #{w&.text}", price[index]&.text.to_s, img.to_s]
    end
  end
end

def product(html_body)
  name = html_body.xpath('//h1[@class="product_main_name"]')
  weight = html_body.xpath('//span[@class="radio_label"]')
  price = html_body.xpath('//span[@class="price_comb"]')
  img = html_body.xpath('//img[@id="bigpic"]/@src')

  save_info(name, weight, img, price)
end

products_url.each do |url|
  current_url = Curl.get(url.text)
  current_html = Nokogiri::HTML(current_url.body)
  product(current_html)
end
puts 'Все файлы записаны'
