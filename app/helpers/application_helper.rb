# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def menu
    x = ""
    Category.menu_items.each do |category|
      x << link_to(category.name.upcase, categorized_path(category.name), :class => "menu") << tag("br")
    end

    x << "<br/><br/><br/><br/><br/><br/>"

    x << link_to("about / contact", about_path, :class => "menu") << "<br/><br/><br/><br/>"

    x << link_to("home", root_path, :class => "menu")
    x
  end

end

