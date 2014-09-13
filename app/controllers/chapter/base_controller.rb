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
    if session[:activity_session_id].blank? && session[:anonymous] == true
      @activity_session = StorySession.new(anonymous: true, activity_uid: session[:uid], access_token: session[:access_token])
      session[:activity_session_id] = @activity_session.id
    else
      @activity_session = StorySession.find(session[:activity_session_id])
    end

    # for compat...
    @score = @activity_session

    # thing_needing_refactor if session[:activity_session_id].blank?

    @chapter_test = ChapterTest.new(self)
  end


end
