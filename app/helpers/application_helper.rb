# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def menu
    x = ""
    Category.menu_items.each do |category|
      x << link_to(category.name.upcase, categorized_path(category.name), :class => "menu") << tag("br")

      if request.url.include? category.name
      # create sub menu
        x << "<div id=submenu>"
        category.top_tags.each_with_index do |tag,index|
          x << link_to("- " + tag.name.downcase + " (" + tag.count.to_s + ")", tagged_with_path(tag.name) + "?category=" + category.name.downcase, :class=>"submenu") << "<br/>"
        end
        x << "</div>"
      end

    end

    x << "<br/><br/><br/><br/><br/><br/>"

    x << link_to("about / contact", about_path, :class => "menu") << "<br/><br/><br/><br/>"

    x << link_to("home", root_path, :class => "menu")
    x
  end

end

