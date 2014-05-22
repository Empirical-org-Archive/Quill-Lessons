class Chapter::BaseController < ApplicationController
  before_filter :find_assignment
  prepend_before_action :requires_activity_session!

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
    @score = if session[:activity_session_id].blank? && session[:anonymous] == true
      story_session = StorySession.new(anonymous: true, activity_uid: session[:uid], access_token: session[:access_token])
      session[:activity_session_id] = story_session.id
      story_session
    else
      StorySession.new(id: session[:activity_session_id], access_token: session[:access_token])
    end

    if session[:activity_session_id].blank?
      @score.activity_uid = session[:uid]
      result = @score.save
      if @score.id.blank?
        data = @score.instance_variable_get(:@data).except(*@score.class.special_attrs.dup)
        serialized_data = {}

        data.each do |key, value|
          serialized_data[key] = value.to_yaml
        end

        params = { data: serialized_data }

        @score.class.special_attrs.each do |attr|
          params[attr] = @score.send(attr)
        end

        params = @score.filter_params(params) if @score.respond_to?(:filter_params)
        result = @score.send(:api).post 'activity_sessions', params
        raise result.inspect if @score.id.blank?
      end
      session[:activity_session_id] = @score.id
    end

    @chapter_test = ChapterTest.new(self)
  end
end
