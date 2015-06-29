class AuthenticationsController < ApplicationController
  skip_before_action :authenticate!

  def redirect
    puts "\n in authenticatison controller, redirect uri : \n #{redirect_uri.to_json}"
    redirect_to client.auth_code.authorize_url(redirect_uri: redirect_uri)
  end

  def callback
    token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
    session[:access_token] = token.token
    session[:user_role] = token.params['user_info']['role'].to_sym
    redirect_to params[:back]
  rescue OAuth2::Error => e
    render text: e.message, head: 500
  end

protected

  def redirect_uri
    oauth_callback_url(back: params[:back]) # your client's redirect uri
  end

  def client
    @client ||= Empirical::Client::Oauth.new
  end
end
