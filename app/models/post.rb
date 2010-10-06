class Post < ActiveRecord::Base

  has_attached_file :image, :styles => { :small => "250x>", :thumb => "128x>" },
                  :url  => "/assets/posts/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/posts/:id/:style/:basename.:extension"

  validates_presence_of :category
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  validates_attachment_size :image, :less_than => 5.megabytes

  acts_as_taggable_on :tags


  belongs_to :category

  attr_accessible :description, :image, :tag_list, :category_id


  def related
    # temp.. needs to be replaced with something else
    Post.find :all, :limit => 5, :order => "rand()"
  end

end

