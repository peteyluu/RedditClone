class CommentsController < ApplicationController
  def new
    @comment = Comment.new(post_id: params[:post_id])
    render :new
  end

  def create
    @comment = Comment.new(params_comment)
    if @comment.save
      redirect_to post_url(@comment.post_id)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def show
    @comment = Comment.find_by_id(params[:id])
    render :show
  end

  def upvote
    @comment = Comment.find_by_id(params[:id])
    @vote = Vote.new(value: 1, votable_id: @comment.id, votable_type: "Comment")
    @vote.save
    redirect_to comment_url(@comment)
  end

  def downvote
    @comment = Comment.find_by_id(params[:id])
    @vote = Vote.new(value: -1, votable_id: @comment.id, votable_type: "Comment")
    @vote.save
    redirect_to comment_url(@comment)
  end

  private
  def params_comment
    params.require(:comment).permit(:content, :user_id, :post_id, :parent_comment_id)
  end
end
