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

  # check if the role returned from the oauth provider is admin. This is only
  # for convenience, the API will enforce roles either way.
  def admin!
    return unless authenticate!

    unless session[:user_role] == :admin
      render text: '', status: :unauthorized
    end
  end

  # this method checks various session and params to establish the current
  # state of authentication. It will handle the case of an anonymous session
  # or an actual session and redirect to oauth provider if necessary.
  def authenticate!
    establish_session_variables_from_initial_module_load

    # we're good to go if it's anon.
    return true if session[:anonymous] == true

    if missing_activity_session?
      raise "We're not anonymous but there is no session id. Cannot continue."
    end

    # if we are at this point then there should definitely be a user signed in
    # on quill as well as a session ID that we can use. If the access token is
    # blank let's redirect to get it.
    access_token!

    true
  end

  def requires_activity_session!
    @requires_activity_session = true
  end

  def missing_activity_session?
    # a session identifier is present. We're good to go.
    return false if session[:activity_session_id].present?

    # If we are loading a module (a.k.a. the activity) a session is required.
    # otherwise we don't need one.
    !!@requires_activity_session
  end

  # this method checks for the presence of an auth token and redirects to the
  # oauth provider if one is not found.
  def access_token!
    if session[:access_token].blank?
      redirect_to oauth_redirect_path(back: request.fullpath)
      return false
    end
  end

  # when Compass first loads a module it will pass in 3 params:
  # * student: the student session id. OR:
  # * anonymous: true. No session id.
  # * uid: there will always be a uid.
  def establish_session_variables_from_initial_module_load
    return unless (params[:student].present? || params[:anonymous]) && params[:uid].present?

    # let's start fresh now.
    access_token = session.delete(:access_token)
    csrf_token = session.delete(:_csrf_token)
    reset_session
    session[:access_token] = access_token if access_token.present?
    session[:_csrf_token] = csrf_token

    # remember the activity id.
    session[:uid] = params[:uid]

    # setup session
    if params[:student].present?
      session[:activity_session_id] = params[:student]
    elsif params[:anonymous]
      session[:anonymous] = true
    else
      raise 'invalid (impossible) scenario.'
    end
  end

  def quill_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{ENV['QUILL_SITE_URL']}"
  end
end
