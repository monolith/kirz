class StoreController < ApplicationController
  before_filter :login_required, :except => [:index ]

  def index
    @products = Product.find :all, :order => "id DESC"
  end

end

