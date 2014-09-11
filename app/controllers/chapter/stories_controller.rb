class Chapter::StoriesController < Chapter::BaseController

  def show
    @assessment = @chapter.assessment
    @body_class = 'con-skyblue'
  end

  def create
    @checker = StoryChecker.new(@score)
    @checker.context = self
    @checker.check_input!(params.delete(:_json))
    @score.state = 'started'
    @score.save

    render layout: false
  end
end
