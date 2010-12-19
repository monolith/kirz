module PostsHelper
  include ActsAsTaggableOn::TagsHelper

  def gallery

    @positions = {  "column1" => { "x" => 0, "y" => 0 },
                  "column2" => { "x" => 257, "y" => 0 },
                  "column3" => { "x" => 514, "y" => 0 }
                }
    @nextColumn = "column1"

    tmp = ""
    @longest = "column1"

    skip = 0            # to make sure two don't appear close to each other

    @posts.each do |post|

      x = @positions[@nextColumn]["x"]
      y = @positions[@nextColumn]["y"]


      size = post.small

      skipColumn = false  # because large images takes up more than one column


      if @nextColumn != "column3" and post.largecrop and rand(10) > 4
        case @nextColumn
          when "column1"
            if @positions["column1"]["y"] == @positions["column2"]["y"]
              if skip == 0
                size = post.large
                @positions["column2"]["y"] = y + post.dimensions(:size => size).height + 7
                skipColumn = true
                skip = 2
              else
                skip = skip - 1
              end
            end
          when "column2"
            if @positions["column2"]["y"] == @positions["column3"]["y"]
              if skip == 0
                size = post.large
                @positions["column3"]["y"] = y + post.dimensions(:size => size).height + 7
                skipColumn = true
                skip = 2
              else
                skip = skip - 1
              end
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
#     the check needed here in order to avoid an error (this is a workaround)

    tmp << "</div><div id=loading style='position: absolute; top:"
    tmp << (@positions[@longest]["y"] + 27).to_s << "px;'></div>"


    tmp

  end


  private


end

