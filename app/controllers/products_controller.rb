class ProductsController < ApplicationController
  before_filter :login_required

  def show
    flash[:error] = "Fool.  You need to draw this first!  Enjoy the store front for now, <B>REFRESH</B> to remove this error message."
    redirect_to store_path
  end

end

