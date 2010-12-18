class AddLargeCropFlag < ActiveRecord::Migration
  def self.up
    add_column :posts, :largecrop, :boolean, :default => true

    Post.update_all ["largecrop = ?", false]
  end

  def self.down
    remove_column :posts, :largecrop
  end
end

