class CommentsController < ApplicationController
    
    def create
        @comment = Comment.new(comment_resource_params)
		@comment.review = Review.find(params[:review_id])
        @comment.user = User.find(session[:user_id])

        @comment.save
        
        redirect_to review_path(@comment.review)
    end

    private

	def comment_resource_params 
		params.require(:comment).permit(:body)
	end
end
