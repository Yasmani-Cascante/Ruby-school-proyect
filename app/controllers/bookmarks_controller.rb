class BookmarksController < ApplicationController
    
    def create
        user = User.find(params[:user_id])
        review = Review.find(params[:review_id])

        unless user.bookmarks.include? review
            user.bookmarks << review
        end
        
        redirect_to(review_path(review))
    end
end
