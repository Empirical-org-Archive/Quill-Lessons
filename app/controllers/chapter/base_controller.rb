class Chapter::BaseController < ApplicationController

  before_filter :find_assignment
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

    if session[:activity_session_id].blank? && session[:anonymous] == true
      @score = StorySession.new(anonymous: true, activity_uid: session[:uid], access_token: session[:access_token])
      session[:activity_session_id] = @score.id
    else
      @score = StorySession.find(session[:activity_session_id])
    end

    # thing_needing_refactor if session[:activity_session_id].blank?


    @chapter_test = ChapterTest.new(self)
  end

  private

  def thing_needing_refactor

    @score.activity_uid = session[:uid]
    result = @score.save

    if @score.id.blank?
      data = @score.activity_session.data.except(*@score.class.special_attrs.dup)
      serialized_data = {}

      data.each do |key, value|
        serialized_data[key] = value.to_yaml
      end

      params = { data: serialized_data }

      @score.class.special_attrs.each do |attr|
        params[attr] = @score.send(attr)
      end

      result = @score.send(:api).post 'activity_sessions', params

      raise "#{params} - #{result.inspect}" if @score.id.blank?
    end
    session[:activity_session_id] = @score.id
  end

end
