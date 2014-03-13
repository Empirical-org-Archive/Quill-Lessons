class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :quill_iframe
  before_action :authenticate!, except: [:start_session]
  helper CMS::Helper

  rescue_from OAuth2::Error do
    session.delete :access_token
    authenticate!
  end

  def root
    # raise session[:user_role].inspect
    if session[:user_role] == :admin
      redirect_to cms_root_path
    else
      render text: '', head: :ok
    end
  end

  def start_session
    session[:start] = true
    redirect_to params[:return]
  end

protected

  def admin!
    return unless authenticate!

    unless session[:user_role] == :admin
      redirect_to root_path
    end
  end

  def authenticate!
    return if session[:anonymous] == true

    # let's remember that the session is anonymous
    if session[:activity_session_id] == :anonymous
      session[:anonymous] = true
      return true
    end

    # if we are at this point then there should definitely be a user signed in on quill as well as a
    # session ID that we can use. If the access token is blank let's redirect to get it.
    if session[:access_token].blank?
      redirect_to oauth_redirect_path(back: request.fullpath)
      return false
    end

    true
  end

  def quill_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{ENV['QUILL_SITE_URL']}"
  end
end
