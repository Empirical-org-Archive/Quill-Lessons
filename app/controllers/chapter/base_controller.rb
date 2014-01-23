class Chapter::BaseController < ApplicationController
  before_filter :find_assignment
  layout 'chapter_test'
  class FlowError < StandardError ; end

  def find_assignment
    @body_class = ''
    @chapter = Story.new(_uid: session[:uid], _cid: session[:cid])

    # first, try and see if they have already started the chapter.
    @score = if session[:student] == :anonymous
      StudentSession.new(:temporary)
    end

    @chapter_test = ChapterTest.new(self)
  end
end
