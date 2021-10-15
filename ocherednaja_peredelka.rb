#  https://www.petsonic.com/farmacia-para-gatos/

require 'curb'
require 'nokogiri'
require 'csv'


# puts 'Введите ссылку'
#
#
@link = 'https://www.petsonic.com/farmacia-para-gatos/'
def html_body(url)
  http = Curl.get(url)
  @html = Nokogiri::HTML(http.body)
end

# def save_info(arr)
#   CSV.open('res.csv', 'a+') do |csv_file|
#     csv_file << %w[Name Price Image] if csv_file.count.zero?
#     csv_file << arr
#   end
# end

# def data(html)
#   html.xpath("//ul[@id='product_list']//a[@class='product-name']").each do |item|
#     products(item.xpath('./@href'))
#   end
# end

def products
  html = html_body(@link)
  name = html.xpath("//h1[@class='product_main_name']/text()").to_s.strip!
  img = html.xpath("//img[@id='bigpic']/@src")
  weight_attr = html.xpath("//div[@class='attribute_list']/ul/li")
  condition(name, img, weight_attr, html)
  puts img.text
end
#
# def condition(name, img, weight_attr, html)
#   if weight_attr.length.positive?
#     weight_attr.each do |weight|
#       name_full = "#{name} - #{weight.xpath("./label/span[@class='radio_label']/text()")}"
#       price = weight.xpath("./label/span[@class='price_comb']/text()")
#       save_info([name_full, price, img])
#     end
#   else
#     price = html.xpath("//span[@id='our_price_display']/text()")
#     condition2(name, price, img)
#   end
# end
#
# def condition2(name, price, img)
#   if name.to_s.empty? || price.to_s.empty? || img.to_s.empty?
#     puts 'Вы указали пустую ссылку('
#   else
#     save_info([name, price, img])
#   end
# end
#
# puts 'Запись началась, ожидайте...'
#
#
# http = Curl.get('https://www.petsonic.com/farmacia-para-gatos/')
# html = Nokogiri::HTML(http.body)
# per_page = html.xpath("//ul[@id='product_list']//a[@class='product-name']").count
# total = html.xpath("//input[@name = 'n']/@value").text.to_i
#
# last_page = (total.to_f / per_page).ceil
# puts last_page
# last_page.times do |page|
#   puts "Запись со страницы № #{page + 1}"
#
#   def html_and_use_xpath(page)
#     http = Curl.get("https://www.petsonic.com/farmacia-para-gatos/?p=#{page}")
#     html = Nokogiri::HTML(http.body)
#     data(html)
#   end
#   html_and_use_xpath(page + 2)
# end



