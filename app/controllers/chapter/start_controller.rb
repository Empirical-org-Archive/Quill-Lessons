class Chapter::StartController < Chapter::BaseController
  prepend_before_filter :set_chapter_id

  def show
    resume and return if @score.unstarted?
    render layout: 'application'
  end

  # Save the score for the activity and present results?
  def final
    # Generate the StorySession percentage value
    @score.finalize!
    @checker = StoryChecker.new(@score, params[:_json])
    render layout: 'application'
  end

protected

  def set_chapter_id
    params[:chapter_id] ||= params[:id]
  end
end
