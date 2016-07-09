# == Schema Information
#
# Table name: post_subs
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  sub_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class PostSub < ActiveRecord::Base
  validates :post_id, :sub_id, presence: true
  # scope, how we can say that the post_id is unique for a given sub_id
  validates :post_id, uniqueness: { scope: :sub_id }
  belongs_to :sub
  belongs_to :post
end
