class SessionsController < ApplicationController
 protect_from_forgery with: :exception
  include SessionsHelper
  def login
  end

  def create
     user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
       log_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
    render 'login'
    end
  end

 
  def destroy
    log_out
    redirect_to root_url
  end
end
