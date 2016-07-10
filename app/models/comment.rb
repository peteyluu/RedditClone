# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  user_id           :integer          not null
#  post_id           :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#  parent_comment_id :integer
#

class Comment < ActiveRecord::Base
  validates :content, :user_id, :post_id, presence: true
  belongs_to :user
  belongs_to :post
  has_many(
    :child_comments,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    primary_key: :id
  )
  belongs_to(
    :parent_comment,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    primary_key: :id
  )

  def child_comments
    @comments = Comment.where(parent_comment_id: self.id)
  end

  def top_level_comments
    @comments = Comment.where(parent_comment_id: nil)
  end

  def has_child_comments?
    @comments = Comment.where(parent_comment_id: self.id)
    return false if @comments.empty?
    true
  end
end
