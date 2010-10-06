class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :category, :tagged_with ]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found


  def index
    @posts = Post.paginate :page => params[:page], :per_page => 12, :order => "ID desc"
    create_columns
    render :index
  end

  def show
    @post = Post.find params[:id], :include => [:category]
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


  def tagged_with
    @posts = Post.tagged_with(params[:tag]).paginate :page => params[:page], :per_page => 12, :order => "ID desc"
    create_columns
    render :index

  end

  def category
    category = Category.find_by_name(params[:name])
    if category
      @posts = category.posts.paginate :page => params[:page], :per_page => 12, :order => "ID desc"
      create_columns
    else
      flash[:error] = "Category not found"
    end
    render :index

  end

private

  def record_not_found
      flash[:error] = "Could not find what you were looking for..."
      redirect_to root_url
  end

  def create_columns
    @column = Array.new
    number_of_columns = 3
    number_of_columns.times { @column << Array.new }

    # creates a multidimentional array, with each array representing a column
    @posts.each_with_index do | post, index |
      @column[index%number_of_columns] << post
    end

  end

end

