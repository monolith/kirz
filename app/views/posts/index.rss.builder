# index.rss.builder
xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.image do
      xml.title "a.r.Kirzhner"
      xml.url formatted_root_url + 'images/logo.png'
      xml.link formatted_root_url
    end


    xml.title "Kirzhner"
    xml.description "The posts of Alex Kirzhner"
    xml.link formatted_root_url
    xml.copyright Time.now.utc.strftime("%Y") + " Alex Kirzhner"


    @posts.each do |post|

      xml.item do
        xml.title "Posted " + post.formatted_created_at
        xml.description link_to(image_tag(formatted_root_url + post.image.url(:small)[1..-1]), formatted_post_url(post))
        xml.link formatted_post_url(post)
      end


    end
  end
end

