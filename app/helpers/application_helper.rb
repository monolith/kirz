# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def menu
    x = ""
    Category.menu_items.each do |category|
      x << link_to("&nbsp;+ " +   category.name.upcase + " ", categorized_path(category.name), :class => menu_class(category)) << "<br />"

      if in_url? category.name or (@post and @post.category == category)
      # create sub menu
        x << "<div id=submenu>"
        category.top_tags.each_with_index do |tag,index|
          x << link_to("&nbsp;- " + tag.name.upcase + " (" + tag.count.to_s + ") ", tagged_with_path(tag.name) + "?category=" + category.name.downcase, :class=>"submenu") << "<br/>"
        end
        x << "</div>"
      end

    end

    x << "<br/><br/><br/><br/><br/><br/>"

    x << link_to("about / contact", about_path, :class => "menu") << "<br/><br/><br/><br/>"

    x << link_to("home", root_path, :class => "menu")
    x
  end

  private

  def menu_class(category)
    if (@post and @post.category == category) or in_url? category.name
      "menu_highlight"
    else
      "menu"
    end
  end

  def in_url?(string)
    request.url.upcase.include? string.upcase
  end

end

