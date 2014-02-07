class Chapter::BaseController < ApplicationController
  before_filter :find_assignment
  layout 'chapter_test'
  class FlowError < StandardError ; end

  def find_assignment
    @body_class = ''

    klass = if params[:step] == 'practice'
      PracticeQuestion
    else
      Story
    end

    @chapter = klass.new(id: session[:uid], access_token: session[:access_token])

    # first, try and see if they have already started the chapter.
    @score = if session[:student] == :anonymous
      story_session = StorySession.new(anonymous: true, activity_uid: session[:uid], access_token: session[:access_token])
      session[:student] = story_session.id
      story_session
    else
      StorySession.new(id: session[:student], access_token: session[:access_token])
    end

    if session[:student].blank?
      @score.activity_uid = session[:uid]
      @score.save
      raise "Failed to set ID" if @score.id.blank?
      session[:student] = @score.id
    end

    @chapter_test = ChapterTest.new(self)
  end
end
