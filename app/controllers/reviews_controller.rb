class ReviewsController < ApplicationController

	def index	
		if(params[:search].blank?)
			@search_term = params[:q]
		else
			@search_term = params[:search]
		end
		@reviews = Review.search(@search_term).descendent
	end

	def show
		@review = Review.find(params[:id])
		@comment = Comment.new

		@created_by = User.find(@review.user_id)
		@user_logged = session[:user_id].present?

		if(@user_logged)
			@user = User.find(session[:user_id])
			@disable_bookmark = @user.bookmarks.exists?(@review.id)
		end
	end

    def new
		if(session[:user_id].present?)
			@review = Review.new
		else
			redirect_to root_path
		end	
	end

    def create
		@review = Review.new(review_resource_params)
        user = User.find(session[:user_id])
        @review.user = user

        if(@review.save)
            redirect_to(root_path)
        else
            render 'new'
        end
	end

	def edit
		if(session[:user_id].present?)
			@review = Review.find(params[:id])		
		else
			redirect_to root_path
		end
	end

	def update
		@review = Review.find(params[:id])

		if(@review.update(review_resource_params))
			redirect_to(reviews_path)
		else
			render 'edit'
		end
	end

	def destroy
		@review = Review.find(params[:id])
		@review.destroy!
		redirect_to(account_reviews_path)
	end

    private

	def review_resource_params 
		params.require(:review).permit(:book_title, :body, :image_url, :book_author)
	end 
end
