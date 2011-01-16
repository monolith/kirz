module Paperclip
  class Largecropper < Thumbnail
    def transformation_command
      if crop_command
        crop_command
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop '#{target.largecrop_w.to_i}x#{target.largecrop_h.to_i}+#{target.largecrop_x.to_i}+#{target.largecrop_y.to_i}' -resize '#{target.largecrop_resize_width}>'"
      end
    end
  end
end

