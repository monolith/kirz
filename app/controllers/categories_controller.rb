class CategoriesController < ApplicationController
  before_filter :login_required

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to categories_url
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find_by_name(params[:id])
  end

  def update
    @category = Category.find_by_name(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to categories_url
    else
      render :action => 'edit'
    end
  end



  def destroy
    @category = Category.find_by_name params[:id]

    if @category.destroy
      flash[:notice] = "The post was deleted."
      redirect_to categories_url
    else
      flash[:error] = "Something happened, could not destroy"
      render :action => :show
    end
  end

end

