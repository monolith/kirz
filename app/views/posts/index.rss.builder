# index.rss.builder
xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.image do
      xml.title "Kirzhner"
      xml.url formatted_root_url + 'images/logo.png'
      xml.link formatted_root_url
    end


    xml.title "Kirzhner"
    xml.description "The posts of Alex Kirzhner"
    xml.link formatted_root_url
    xml.copyright "Alex Kirzhner"


    @posts.each do |post|

      xml.item do
#        xml.id formatted_post_url(post)
        xml.title "Posted " + time_ago_in_words(post.created_at)

        xml.description post.description
        xml.link formatted_post_url(post)

#        xml.enclosure :type => "image/jpeg", :url => formatted_root_url + post.image.url(:small)[1..-1], :length => "12216320"
#        xml.enclosure :type => "image/jpeg", :url => "http://localhost:3000/assets/posts/48/small/mario4.jpg", :length => "1221632", :width=>250



#        <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />
#        xml.link :rel=>"alternate", :type=>"text/html", :href=> formatted_post_url(post)
#        xml.link :href => formatted_root_url + post.image.url(:small)[1..-1], :rel=>"enclosure", :type=>"image/jpeg"


#        xml.content "hi", :type => "html"
#<content type="html">
#			<p><a href="http://www.flickr.com/people/mascenon_a/">Adrian.M</a> posted a photo:</p>
#
#<p><a href="http://www.flickr.com/photos/mascenon_a/5074265123/" title="_DSC0007"><img src="http://farm5.static.flickr.com/4001/5074265123_2f4760310b_m.jpg" width="240" height="159" alt="_DSC0007" /></a></p>

#</content>

 #       xml.published post.created_at
  #      xml.updated post.updated_at



#    <link rel="alternate" type="text/html" href="http://www.flickr.com/photos/mascenon_a/5074265123/"/>
#    <id>tag:flickr.com,2005:/photo/5074265123</id>
#    <published>2010-10-12T09:17:12Z</published>
#    <updated>2010-10-12T09:17:12Z</updated>


#        xml.image do
#          xml.title "New " + post.category.name.singularize.capitalize
#          xml.url formatted_root_url + 'images/logo.png'

#          xml.url  formatted_root_url + post.image.url(:small)[1..-1]
#          xml.link formatted_post_url(post)

 #       end

#        xml.category post.category.name

#        xml.tags do
#          post.tags.each do |tag|
#            xml.tag tag.name
#          end
#        end

#        xml.pubDate post.created_at.to_s(:rfc822)
#        xml.guid formatted_post_url(post, :rss)

      end


    end
  end
end

