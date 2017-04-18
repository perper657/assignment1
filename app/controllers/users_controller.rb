class UsersController < ApplicationController
    before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
    before_action :correct_user,   only: [:edit, :update]
    before_action :admin_user,     only: [:edit, :destroy,:index]
  def login
    @user = User.new
  end
  def index
    @users = User.where(activated: FILL_IN).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless FILL_IN
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
   def user_params
      params.require(:user).permit(:name, :surname, :email, :password,
                                   :password_confirmation)
   end
   def edit
    @user = User.find(params[:id])
   end
   
     def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
         flash[:success] = "Profile updated"
      redirect_to @user
        else
          render 'edit'
        end
     end
    def logged_in_user
      unless logged_in?
      store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end
end
