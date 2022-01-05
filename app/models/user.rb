class User < ApplicationRecord
	validates :email, format: /@/

	has_many :reviews
	has_many :comments
	has_and_belongs_to_many :bookmarks, class_name: 'Review'
end
