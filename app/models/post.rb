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


  def similar
    all = Post.search "#{tag_list.to_s}, #{category.name}, #{description}",
                :include => [:category, :tags],
                :field_weights => {
                  "tags" => 3,
                  "category" => 2,
                  "description" => 1
                },
                :match_mode => :any,
                :without => {:id => id}, # should not find self
                :order => "@relevance DESC, created_at DESC",
               :limit => 30

    # the above can return up to 30 results (whatever is set in the limit)
    # only a subset will actually be displayed, i.e. 7
    # the below takes a randomized sample

    count = all.count

    if count > 7
      random_positions = (0...count).to_a.sort_by{rand}.first(2).sort

      random =[]
      random_positions.each do |position|
        random << all[position]
      end

      return random
    else
      return all
    end
  end




  # SEARCHING INDEXING
  define_index do
    # fields
    indexes category.name, :as => :category, :sortable => true
    indexes tags.name, :as => :tags, :sortable => true
    indexes description

    # attributes
    has created_at
    has :id
  end

end

