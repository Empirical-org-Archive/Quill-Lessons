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
    session[:uid] = params[:uid]

    session[:activity_session_id] = if params[:anonymous]
      :anonymous
    else
      params[:student]
    end

    show_story
  end

  def homepage
    session[:uid] = params[:uid]
    session[:activity_session_id] = :anonymous
    show_story
  end

protected

  def show_story
    Story.new(id: session[:uid])
    @story = Story.new(id: session[:uid], access_token: session[:access_token])
    @assessment = @story.assessment
    render :homepage
  end
end
