class AddMenuorderToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :menuorder, :integer
  end

  def self.down
    remove_column :categories, :menuorder
  end
end

