class Review < ApplicationRecord
	validates :book_title, presence: true
    validates :book_author, length: { maximum: 100 }
    
	belongs_to :user
	has_many :comments
	has_and_belongs_to_many :users

	def self.search(search_term)
		card_filter = "%#{search_term}%"
		where('book_title LIKE ?', card_filter).or(where('book_author LIKE ?', card_filter))
	end
	
	def self.most_recent()
		all.order(created_at: :desc).limit(6)
	end

	def self.descendent()
		all.order(created_at: :desc)
	end
end
