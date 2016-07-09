# == Schema Information
#
# Table name: subs
#
#  id           :integer          not null, primary key
#  moderator_id :integer          not null
#  title        :string           not null
#  description  :text             not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Sub < ActiveRecord::Base
  validates :moderator_id, :title, :description, presence: true

  belongs_to(
    :moderator,
    class_name: "User",
    foreign_key: :moderator_id,
    primary_key: :id
  )

  # if a sub is suddenly destroyed, we would like to destroy its forward
  # association "post_subs"
  has_many :post_subs, dependent: :destroy
  has_many :posts, through: :post_subs, source: :post
end
