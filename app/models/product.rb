class Product < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :post, :message => "must be attached to a product"


  def price
    75
  end

  def quantity
    5
  end

  def name
    "Demon Walker #{ rand(50) }"
  end

  def description
    "Special Sauce " + (0...8).map{65.+(rand(25)).chr}.join
  end

end

