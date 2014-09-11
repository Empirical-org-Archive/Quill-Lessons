class StoriesController < ActivityController

  before_action :load_record

  def module
    render :homepage
  end

  def homepage
    render :homepage
  end


  private

  def load_record
    @story = Story.find(params[:uid])
    @assessment = @story
  end
end
