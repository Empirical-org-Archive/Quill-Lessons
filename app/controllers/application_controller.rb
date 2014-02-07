class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :quill_iframe
  before_action :authenticate!
  helper CMS::Helper

  rescue_from OAuth2::Error do
    session.delete :access_token
    authenticate!
  end

  def root
    render text: '', head: :ok
  end

protected

  def authenticate!
    if session[:access_token].blank? && params[:anonymous].blank? && session[:student].blank?
      redirect_to oauth_redirect_path(back: request.fullpath)
    end
  end

  def quill_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{ENV['QUILL_SITE_URL']}"
  end
end
