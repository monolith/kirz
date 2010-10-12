class PostsController < ApplicationController
  require 'uri'

  before_filter :login_required, :except => [:index, :show, :categorized, :tagged_with, :search ]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found


  def index

    per_page = 12

    @posts = Post.paginate :page => params[:page], :per_page => per_page, :order => "ID desc"

    create_columns
    render :index
  end

  def show
    @post = Post.find params[:id], :include => [:category]
    create_similar_columns

    flash[:error] = "The logic for similar is turned off, the below is only to show the layout" if RAILS_ENV == "production"

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

  def categorized
    category = Category.find_by_name params[:name]
    @posts = category.posts.paginate :page => params[:page], :per_page => 12, :order => "ID desc"

    create_columns
    render :index
  end

  def search
    if params[:query]  # hackity
      redirect_to '/search/' + URI.escape(params[:query], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      return
    else
      per_page = 12

      if RAILS_ENV == "production"
        @posts = Post.paginate :page => params[:page], :per_page => per_page, :order => "ID desc"
        flash[:error] = "sorry, search is disabled here.  Showing regular home page"
      else

        @posts = Post.search params[:search],
                            :include => [:category, :tags],
                            :field_weights => {
                              "tags" => 3,
                              "category" => 2,
                              "description" => 1
                            },
                            :match_mode => :any,
                            :page          => params[:page],
                            :per_page => per_page,
                            :order => "@relevance DESC, created_at DESC"
      end

      @query = params[:search]
      create_columns
      render :index
    end
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

  def create_similar_columns
    @column = Array.new
    number_of_columns = 4
    number_of_columns.times { @column << Array.new }

    # creates a multidimentional array, with each array representing a column
    @post.similar.each_with_index do | post, index |
      @column[index%number_of_columns] << post
    end

  end


end

