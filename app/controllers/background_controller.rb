class BackgroundController < ApplicationController
  def random
    images = [ "bg1.jpg",
               "bg2.jpg",
               "bg3.jpg"
             ].sort_by { rand }
    redirect_to "/images/backgrounds/#{images[0]}"
  end
end

