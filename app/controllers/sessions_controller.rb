class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:last_rating] = user.ratings.last.for_session unless user.ratings.empty?
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    session[:last_rating] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
