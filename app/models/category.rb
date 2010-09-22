class Category < ActiveRecord::Base
  validates_uniqueness_of   :name
  attr_accessible :name

  has_many :posts

  def self.menu_items
    Category.find :all, :order => "name"
  end

end

