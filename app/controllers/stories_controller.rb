class StoriesController < ActivityController

  before_action :load_record

  def module
    show_story
  end

  def homepage
    load_record
    show_story
  end


  private

  def load_record
    @story = Story.find(params[:uid])
  end

protected

  def model
    Story
  end

  def subject
    :story
  end

  def show_story
    @assessment = @story.assessment
    render :homepage
  end
end
