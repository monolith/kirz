module Paperclip
  class Smallcropper < Thumbnail
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
        " -crop '#{target.smallcrop_w.to_i}x#{target.smallcrop_h.to_i}+#{target.smallcrop_x.to_i}+#{target.smallcrop_y.to_i}' -resize '250>'"
      end
    end
  end
end

