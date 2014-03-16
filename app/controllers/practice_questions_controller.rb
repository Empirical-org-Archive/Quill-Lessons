class PracticeQuestionsController < ActivityController
  def module
    redirect_to chapter_practice_index_path(session[:uid])
  end

protected

  def model
    PracticeQuestion
  end

  def subject
    :practice_question
  end
end
