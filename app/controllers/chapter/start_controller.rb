class Chapter::StartController < Chapter::BaseController
  prepend_before_filter :set_chapter_id

  def show
    resume and return if @score.unstarted?
    render layout: 'application'
  end

  def final
    @score.finalize!
    @checker = StoryChecker.new(@score)
    render layout: 'application'
  end

protected

  def set_chapter_id
    params[:chapter_id] ||= params[:id]
  end
end
