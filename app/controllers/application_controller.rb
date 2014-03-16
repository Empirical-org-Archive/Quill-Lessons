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
      render text: '', status: :ok
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
      render text: '', status: :unauthorized
    end
  end

  def authenticate!
    establish_session_variables_from_initial_module_load

    # we're good to go if it's anon.
    return true if session[:anonymous] == true

    if session[:activity_session_id].blank?
      raise "We're not anonymous but there is no session id. Cannot continue."
    end

    # if we are at this point then there should definitely be a user signed in on quill as well as a
    # session ID that we can use. If the access token is blank let's redirect to get it.
    access_token!

    true
  end

  def access_token!
    if session[:access_token].blank?
      redirect_to oauth_redirect_path(back: request.fullpath)
      return false
    end
  end

  def establish_session_variables_from_initial_module_load
    # when Compass first loads a module it will pass in 3 params:
    # * student: the student session id. OR:
    # * anonymous: true. No session id.
    # * uid: there will always be a uid.
    return unless (params[:student].present? || params[:anonymous]) && params[:uid].present?

    # let's start fresh now.
    access_token = session.delete(:access_token)
    csrf_token = session.delete(:_csrf_token)
    reset_session
    session[:access_token] = access_token if access_token.present?
    session[:_csrf_token] = csrf_token

    session[:uid] = params[:uid]

    if params[:student].present?
      session[:activity_session_id] = params[:student]
    elsif params[:anonymous]
      session[:anonymous] = true
    else
      raise 'invalid scenario.'
    end
  end

  def quill_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{ENV['QUILL_SITE_URL']}"
  end
end
