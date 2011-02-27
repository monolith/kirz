class Category < ActiveRecord::Base
  validates_uniqueness_of   :name, :menuorder
  attr_accessible :name, :menuorder

  has_many :posts

  def self.menu_items
    Category.find :all, :order => "menuorder"
  end

  def top_tags(max = 5)
    posts.tag_counts.order('count DESC, id DESC').limit(5)
  end

  def to_param
    name
  end

end

