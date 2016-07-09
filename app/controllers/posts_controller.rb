class PostsController < ApplicationController
  before_action :require_login!, only: [:new, :create]
  before_action :require_author!, only: [:edit, :update]

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      params[:post][:sub_ids].each do |sub_id|
        PostSub.create!(post_id: @post.id, sub_id: sub_id)
      end
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find_by_id(params[:id])
    render :show
  end

  def edit
    @post = Post.find_by_id(params[:id])
    render :edit
  end

  def update
    @post = Post.find_by_id(params[:id])
    @post.update_attributes(post_params)
    redirect_to post_url(@post)
  end

  # Structured the HTML form to upload an array of sub_ids nested under post
  # Updated the PostsController#post_params to accept an array of sub_ids

  # You should now be able to associate a post to the subs that you selected.
  # This works b/c the Post#subs association gives us a method, Post#sub_ids=,
  # which will automatically create/destroy the neccessary entries in the
  # PostSub join table.
  # Recall that Rails will call a setter method for each attribute that you
  # assign in Post.new or Post#update, so if one of the keys in our attributes
  # is sub_ids, Rails will automatically call Post#sub_ids=.

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :user_id, :sub_id)
  end

  def require_author!
    @post = Post.find_by_id(params[:id])
    if !author?
      flash.now[:errors] = "Only authors allowed to edit this post!"
      redirect_to post_url(@post)
    end
  end

  def author?
     @post = Post.find_by_id(params[:id])
    @post.user_id == current_user.id
  end
end
