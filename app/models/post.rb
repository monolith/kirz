class Post < ActiveRecord::Base

  has_attached_file :image, :styles => { :small_landscape => "250x184#", :small_portfolio => "250x375#", :thumb => "128x>", :largecrop => "507x375#" },
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
    if RAILS_ENV == "staging"
      Post.all.first(7)
    else

      all = Post.search "#{tag_list.to_s}, #{category.name if category}, #{description}",
                  :include => [:category, :tags],
                  :field_weights => {
                    "tags" => 3,
                    "category" => 1,
                    "description" => 5
                  },
                  :match_mode => :any,
                  :without => {:id => id}, # should not find self
                  :order => "@relevance DESC, created_at DESC",
                 :limit => 14

      # the above can return more results than what we need (whatever is set in the limit)
      # only a subset will actually be displayed, i.e. 7
      # the below takes a randomized sample

      count = all.size

      if count > 7
        random_positions = (0...count).to_a.sort_by{rand}.first(7).sort

        random =[]
        random_positions.each do |position|
          random << all[position]
        end

        return random
      else
        return all
      end
    end
  end


  def self.last_post_time
    if Post.count > 0
      Post.formatted_date Post.last.created_at
    else
      "NEVER!"
    end
  end

  def formatted_created_at
    Post.formatted_date created_at
  end


  def formatted_created_at_date
    Post.formatted_date_only created_at
  end

  def self.formatted_date(t)
    h = t.strftime('%I').to_i.to_s

    meridian = t.strftime('%p').insert(1,'.').insert(3, '.')

    x = t.strftime('%B %d, %Y at ') + h + t.strftime(':%M:%S ') + meridian
    x.downcase  + " " + t.zone.upcase
  end

  def self.formatted_date_only(t)
    t.strftime('%B %d, %Y').downcase
  end


  def dimensions(options={})
     size = options[:size] || :original
     geo = Paperclip::Geometry.from_file(image.to_file(size))

     return geo
  end


  def next
    Post.find :first, :conditions => ['id > ?', id], :order => "id"
  end

  def previous
    Post.find :first, :conditions => ['id < ?', id], :order => "id DESC"
  end

  def small
    d = dimensions

    if largecrop # backward compatibility check
      d.height > d.width ? :small_portfolio : :small_landscape
    else
      :small
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

    set_property :delta => true

  end

end

