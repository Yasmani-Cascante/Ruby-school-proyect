class AccountController < ApplicationController

	def bookmarks
		if(session[:user_id].present?)
			user = User.find(session[:user_id])
			@reviews = user.bookmarks
		else
			redirect_to root_path
		end
	end

	def reviews
		if(session[:user_id].present?)
			user = User.find(session[:user_id])
			@reviews = user.reviews.most_recent()
		else
			redirect_to root_path
		end
	end

	def destroy
		review = Review.find(params[:id])
		user = User.find(session[:user_id])
		user.bookmarks.destroy(review)
		redirect_to(account_bookmarks_path)
	end

	def logout
		session.delete(:user_id)
		redirect_to root_path
	end
end
