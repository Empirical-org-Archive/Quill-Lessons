class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :quill_iframe
  helper CMS::Helper

protected

  def quill_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{'http://localhost:3000/'}"
  end
end
