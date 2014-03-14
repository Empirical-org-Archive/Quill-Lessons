class PracticeQuestionsController < ApplicationController
  def form
    @story = PracticeQuestion.new(id: params[:uid], access_token: session[:access_token])
  end

  def save
    @story = PracticeQuestion.new(params[:story])

    unless @story.save
      render :form
    end
  end

  def module
    redirect_to chapter_practice_index_path(session[:uid])
  end
end
