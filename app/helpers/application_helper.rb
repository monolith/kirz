# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def menu
    x = ""
    Category.menu_items.each do |category|
      x << link_to(category.name, category_path(category.name), :class => "menu") << tag("br")
    end
    x
  end

end

