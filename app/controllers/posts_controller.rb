class PostsController < ApplicationController
  skip_before_filter :require_login, :only => [:index, :show]

  def index
    @posts = Post.search(query_params[:query]).includes(:tags)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(whitelisted_post_params)
    if @post.save
      # Woohoo
      redirect_to @post
    else
      # boohoo
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(whitelisted_post_params)
      redirect_to @post
    else
      render :edit
    end
  end

  def destroy
    Post.find(params[:id]).destroy!
    redirect_to posts_path
  end



  private

  def whitelisted_post_params
    if params[:post].is_a?(ActionController::Parameters)
      params.require(:post).permit(:title, :body,  :author_id, :tag_ids => [])
    else
      {:title => params[:title], :body => params[:body]}
    end
  end

  def query_params
    params.permit(:query => [:title, :body])
  end

end
