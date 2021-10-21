# frozen_string_literal: true

require_relative 'functionable'

class Product

  attr_accessor :name, :price, :img

  def initialize(name, price, img)
    @name = name
    @price = price
    @img = img
  end

  include Functions

  def self.save_info(product_array)
    CSV.open(YML['FILE_NAME'], 'a+') do |csv_file|
      csv_file << %w[Name Price Image] if csv_file.count.zero?
      product_array.each do |product|
        csv_file << [product.name, product.price, product.img]
      end
    end
  end
end
