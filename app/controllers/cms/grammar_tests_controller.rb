class CMS::GrammarTestsController < CMS::BaseController
  helper_method :subject
  before_filter :admin!

  protected

  def subject
    CMS::GrammarTest
  end
end
