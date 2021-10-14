#  https://www.petsonic.com/farmacia-para-gatos/

require 'curb'
require 'nokogiri'
require 'csv'

def save_info(arr)
  CSV.open('result_of_parsing.csv', 'a+') do |csv_file|
    csv_file << %w[Name Price Image] if csv_file.count.zero?
    csv_file << arr
  end
end

def data(html)
  html.xpath("//ul[@id='product_list']//a[@class='product-name']").each do |item|
    products(item.xpath('./@href'))
  end
end

def products(url)
  http = Curl.get(url.to_s)
  html = Nokogiri::HTML(http.body)
  name = html.xpath("//h1[@class='product_main_name']/text()").to_s.strip!
  img = html.xpath("//img[@id='bigpic']/@src")
  weight_attr = html.xpath("//div[@class='attribute_list']/ul/li")
  conditions(name, img, weight_attr, html)
end

def conditions(name, img, weight_attr, html)
  if weight_attr.length.positive?
    weight_attr.each do |weight|
      name_full = "#{name} - #{weight.xpath("./label/span[@class='radio_label']/text()")}"
      price = weight.xpath("./label/span[@class='price_comb']/text()")
      save_info([name_full, price, img])
    end
  else
    price = html.xpath("//span[@id='our_price_display']/text()")
    if name.to_s.empty? || price.to_s.empty? || img.to_s.empty?
      puts 'Вы указали пустую ссылку('
    else
      save_info([name, price, img])
    end
  end
end

puts 'Запись началась, ожидайте...'
page = 1
http = Curl.get('https://www.petsonic.com/farmacia-para-gatos/')
html = Nokogiri::HTML(http.body)

last_page = html.xpath("//ul[contains(@class, 'pagination')]/li[position() = (last() - 1)]/a/span/text()").to_s

loop do
  puts "Запись со страницы №#{page}"
  data(html)
  page += 1
  if page <= last_page.to_i
    http = Curl.get("https://www.petsonic.com/farmacia-para-gatos/?p=#{page}")
    html = Nokogiri::HTML(http.body)
  else
    puts "Запись была закончена на странице:#{page - 1}."
    break
  end
end



