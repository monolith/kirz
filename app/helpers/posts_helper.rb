module PostsHelper
  include ActsAsTaggableOn::TagsHelper

  def gallery

    @positions = {  "column1" => { "x" => 0, "y" => 0 },
                  "column2" => { "x" => 257, "y" => 0 },
                  "column3" => { "x" => 514, "y" => 0 }
                }
    @nextColumn = "column1"

    tmp = ""

    @posts.each do |post|

      x = @positions[@nextColumn]["x"]
      y = @positions[@nextColumn]["y"]


      size = :small
      skipColumn = false

      if post.largecrop and @nextColumn != "column3" and rand(10) > 5
        case @nextColumn
          when "column1"
            if @positions["column1"]["y"] == @positions["column2"]["y"]
              size = :largecrop
              @positions["column2"]["y"] = y + post.dimensions(:size => size).height + 7
              skipColumn = true
            end
          when "column2"
            if @positions["column2"]["y"] == @positions["column3"]["y"]
              size = :largecrop
              @positions["column3"]["y"] = y + post.dimensions(:size => size).height + 7
              skipColumn = true
            end
        end

      end

      @positions[@nextColumn]["y"] = y + post.dimensions(:size => size).height + 7

      tmp << link_to( image_tag( post.image.url(size),
                                  :class => "newthumb",
                                  :style=>"position:absolute; top: #{y}px;left: #{x}px;"
                              ),
                              post_path(post)
                     )

      # adjust next column to make sure any one column doesn't get much longer than another
      # picks shortest column for next post
      # also find longest column, to better place pagination (below)


      @positions.each_pair do |key, position|
        debugger
        if @positions[@nextColumn]["y"] > position["y"]
          @longest = @nextColumn # for pagination
          @nextColumn = key
        elsif @positions[@nextColumn]["y"] == position["y"]
          @longest = @nextColumn # for pagination

          case key
            when "column1"
              @nextColumn = key
            when "column2"
              @nextColumn = key if @nextColumn == 3
          end
        end


      end


    end


    # pagination

    tmp <<   "<div id=pagination style='position: absolute; top:"
    tmp << (@positions[@longest]["y"] + 7).to_s << "px;'>"

    tmp << will_paginate(@posts) if @posts.total_entries > @posts.count # checks first if pagination is needed
    # the check needed here in order to avoid an error (this is a workaround)

    tmp << "</div><div id=loading style='position: absolute; top:"
    tmp << (@positions[@longest]["y"] + 27).to_s << "px;'></div>"


    tmp

  end


  private


end

