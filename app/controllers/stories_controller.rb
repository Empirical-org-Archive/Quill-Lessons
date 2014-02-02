class StoriesController < ApplicationController
  before_filter :quill_iframe

  def form
    @story = Story.new(_uid: params[:uid], _cid: params[:cid])
  end

  def save
    @story = Story.new(params[:story])

    unless @story.save
      render :form
    end
  end

  def module
    session[:uid] = params[:uid]
    session[:cid] = params[:cid]
    session[:student] = params[:student]

    redirect_to
  end

  def homepage
    session[:uid] = params[:uid]
    session[:cid] = params[:cid]
    session[:student] = :anonymous
    @story = Story.new(_uid: session[:uid], _cid: session[:cid])
    @assessment = @story.assessment
  end

protected

  def quill_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{ENV['QUILL_MAIN_APP_URL']}"
  end
end
