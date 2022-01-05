class UsersController < ApplicationController

    def new
        @user = User.new			
	end

    def create
        @user = User.find_or_create_by(user_params)
        
        if(@user.valid?)
            session[:user_id] = @user.id
            redirect_to account_bookmarks_path
        else
            render 'new'
        end 
    end

	private

    def user_params
        params.require(:user).permit(:email)
	end
end
