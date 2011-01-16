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

      size = :small

      skipColumn = false  # because large images takes up more than one column


      if post.largecrop and rand(10) > 4
        dimensions = post.dimensions(:size => :largecrop)

        colspan = 1
        if dimensions.width > 507
          colspan=3
        elsif dimensions.width > 250
          colspan=2
        end

        case @nextColumn
          when "column1"

            case colspan
              when 1

                if skip == 0
                  size = :largecrop
                  skipColumn = true
                  # to reduce occurance of large crops showing up close to each other
                  skip = 2
                else
                  skip = skip - 1
                end

              when 2
                if @positions["column1"]["y"] == @positions["column2"]["y"]
                  if skip == 0
                    size = :largecrop
                    @positions["column2"]["y"] = y + dimensions.height + 7
                    skipColumn = true

                    # to reduce occurance of large crops showing up close to each other
                    skip = 2
                  else
                    skip = skip - 1
                  end

                end
              when 3

                if @positions["column1"]["y"] == @positions["column2"]["y"] and @positions["column2"]["y"] == @positions["column3"]["y"]
                  if skip == 0
                    size = :largecrop
                    @positions["column2"]["y"] = y + dimensions.height + 7
                    @positions["column3"]["y"] = y + dimensions.height + 7

                    skipColumn = true

                    # to reduce occurance of large crops showing up close to each other
                    skip = 2
                  else
                    skip = skip - 1
                  end
                end

            end


          when "column2"
            case colspan
              when 1
                if skip == 0
                  size = :largecrop
                  skipColumn = true
                  # to reduce occurance of large crops showing up close to each other
                  skip = 2
                else
                  skip = skip - 1
                end

              when 2

                if @positions["column2"]["y"] == @positions["column3"]["y"]
                  if skip == 0
                    size = :largecrop

                    @positions["column3"]["y"] = y + dimensions.height + 7
                    skipColumn = true

                    # to reduce occurance of large crops showing up close to each other
                    skip = 2
                  else
                    skip = skip - 1
                  end
                end

                # nothing if colspan is 3, no room!
            end

          when "column3"

            if colspan == 1 # else too big to include in this column
              if skip == 0
                size = :largecrop
                skipColumn = true
                skip = 2
              else
                skip = skip -1
              end

            end

        end

      end # if - random

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
          @nextColumn = key
        elsif @positions[@nextColumn]["y"] == position["y"]

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
    tmp << (@positions["column1"]["y"] + 7).to_s << "px;'>"

    tmp << will_paginate(@posts) if @posts.total_entries > @posts.count # checks first if pagination is needed
#     the check needed here in order to avoid an error (this is a workaround)

    tmp << "</div><div id=loading style='position: absolute; top:"
    tmp << (@positions["column1"]["y"] + 27).to_s << "px;'></div>"


    tmp

  end



  def disableIfSmallerThan(options={})
    geo = @post.dimensions(:size => options[:size])

    "disabled='disabled'" if geo.width < options[:width] or geo.height < options[:height]

  end

  private


end

