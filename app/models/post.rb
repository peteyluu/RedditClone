# == Schema Information
#
# Table name: posts
#
#  id      :integer          not null, primary key
#  title   :string(255)      not null
#  url     :string(255)
#  content :text
#  user_id :integer          not null
#

class Post < ActiveRecord::Base
  validates :title, :user_id, presence: true
  belongs_to :user
  has_many :post_subs, dependent: :destroy
  has_many :subs, through: :post_subs, source: :sub
  has_many :comments
  has_many :votes, as: :votable

  def comments_by_parent_id
    comments_by_parent_id = Hash.new { |hash, key| hash[key] = [] }
    self.comments.includes(:user).each do |comment|
      comments_by_parent_id[comment.parent_comment_id] << comment
    end
    comments_by_parent_id
  end

  def vote_sum_votable_id
    Vote.where(votable_id: self.id).sum(:value)
  end
end
