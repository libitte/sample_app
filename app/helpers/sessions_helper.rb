module SessionsHelper

  def sign_in(user)
    # tokenを新規作成する
    remember_token = User.new_remember_token
    # 暗号化されていないtokenをbrowserのcookiesに保存する
    cookies.permanent[:remember_token] = remember_token
    # 暗号化したtokenをDBに保存する
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # 与えられたユーザーを現在のユーザーに設定する
    # self.current_user= というインスタンスメソッドの呼び出し
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
