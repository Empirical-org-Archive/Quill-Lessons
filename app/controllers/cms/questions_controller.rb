class CMS::QuestionsController < CMS::BaseController
  helper_method :subject
  before_filter :admin!

  protected

  def subject
    Question
  end
end
