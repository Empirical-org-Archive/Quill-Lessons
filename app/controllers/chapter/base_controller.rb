class Chapter::BaseController < ApplicationController

  before_filter :find_assignment
  before_filter :set_activity_session

  prepend_before_action :requires_activity_session!

  layout 'chapter_test'
  class FlowError < StandardError ; end

  def find_assignment
    @body_class = ''

    if params[:step] == 'practice'
      @chapter = PracticeQuestion.find(session[:uid])
    else
      @chapter = Story.find(session[:uid])
    end
  end

  def set_activity_session
    if session[:activity_session_id].present?
      @activity_session = StorySession.find(session[:activity_session_id])
    elsif params[:score_id].present?
      @activity_session = StorySession.find(params[:score_id])
    elsif session[:anonymous] == true
      @activity_session = StorySession.new(anonymous: true, activity_uid: session[:uid], access_token: session[:access_token])
      @activity_session.save
    elsif session[:uid].present?
      @activity_session = StorySession.new(anonymous: false, activity_uid: session[:uid], access_token: session[:access_token])
      @activity_session.save
    end

    unless @activity_session.nil?
      # force reset the session id..
      session[:activity_session_id] = @activity_session.uid
    end

    # for compat...
    @score = @activity_session
    @chapter_test = ChapterTest.new(self)
  end


end
