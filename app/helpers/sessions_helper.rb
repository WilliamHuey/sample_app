module SessionsHelper

# tweaked more from bottom
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id]
    session[:user_id] = user.id
    current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    session[:user_id] = nil
    current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  private

    def user_from_remember_token
        remember_token = cookies[:remember_token]
        User.find_by_remember_token(remember_token) unless remember_token.nil?
    end

    def remember_token
        cookies.signed[:remember_token] || [nil, nil]
    end

    def clear_return_to
      session.delete(:return_to)
    end

=begin
#slight tweak from original
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    session[:user_id] = user.id
    current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    session[:user_id] = nil
    current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  private
   def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end
=end

=begin
#before the exercise
  def sign_in(user)
    cookies.permanent.[:remember_token] = user.remember_token
    current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end

  private

  def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end
=end
end
