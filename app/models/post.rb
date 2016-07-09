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
end
