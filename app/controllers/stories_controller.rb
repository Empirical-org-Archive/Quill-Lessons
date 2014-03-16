class StoriesController < ActivityController
  def module
    show_story
  end

  def homepage
    load_record
    show_story
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
