class Comment < ApplicationRecord
	validates :body, presence: true

	belongs_to :user
	belongs_to :review

  def self.most_recent()
		all.order(created_at: :desc).limit(5)
	end

end
