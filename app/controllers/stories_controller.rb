class StoriesController < ApplicationController
  def form
    @story = Story.new(id: params[:uid], access_token: session[:access_token])
  end

  def save
    @story = Story.new(params[:story].merge(access_token: session[:access_token]))

    unless @story.save
      render :form
    end
  end

  def module
    session[:activity_session_id] = if params[:anonymous]
      session.delete :access_token
      :anonymous
    else
      params[:student]
    end

    show_story
  end

  def homepage
    session[:activity_session_id] = :anonymous
    show_story
  end

protected

  def show_story
    session[:uid] = params[:uid]
    Story.new(id: session[:uid])
    @story = Story.new(id: session[:uid], access_token: session[:access_token])
    @assessment = @story.assessment
    render :homepage
  end
end
