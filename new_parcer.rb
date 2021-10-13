#  https://www.petsonic.com/farmacia-para-gatos/

require 'curb'
require 'nokogiri'
require 'csv'
puts 'Укажите ссылку на категорию'
link = gets.chomp


def save_info(name, weight, img, price)
  weight.each_with_index do |w, index|
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


# https://www.petsonic.com/farmacia-para-gatos/


# https://www.petsonic.com/farmacia-para-gatos/
# prod_num = html.xpath('//h1[@class="product_main_name"]').size
# (0..prod_num).each do num
# nameArr = name
#