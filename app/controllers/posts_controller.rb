class PostsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found


  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])

  end

  def new
    @post = Post.new
  end

  def create

    @post = Post.new(params[:post])


    if @post.save
      flash[:notice] = "Successfully created post."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Successfully updated post."
      redirect_to root_url
    else
      render :action => 'show'
    end
  end

    def destroy
      @post = Post.find params[:id]

      if @post.destroy
        flash[:notice] = "The post was deleted."
        redirect_to root_url
      else
        flash[:error] = "Something happened, could not destroy"
        render :action => :show
      end
  end


private

  def record_not_found
      flash[:error] = "Could not find what you were looking for..."
      redirect_to root_url
  end

end

