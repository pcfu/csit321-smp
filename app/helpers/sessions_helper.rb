module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end

  def logged_in?
    current_user.present?
  end

  #Adding a helper to check whether user is logged in
  def logged_in_user
    if !(logged_in?)
       flash[:danger] = "Please log in."
       redirect_to sessions_url
    end
 end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def redirect_if_not_admin
    return redirect_to sessions_url if !logged_in?       # login page if not logged in
    return redirect_to root_url if !current_user.admin?  # landing page if regular user
  end
end
