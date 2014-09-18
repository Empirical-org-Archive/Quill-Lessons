class Chapter::StoriesController < Chapter::BaseController

  def show
    @assessment = @chapter.assessment
    @body_class = 'con-skyblue'
  end

  def create
    Raven.extra_context(params: params)
    Raven.extra_context(session: session.to_hash)
    Raven.extra_context(activity_session: @activity_session)

    # do some error handling if bad data presented
    if params[:_json].blank?
      render layout: false and return
    end

    @activity_session.start!
    @activity_session.check_submission(params[:_json])

    @activity_session.save
    session[:activity_session_id] = @activity_session.activity_session.uid

    # sugar, for ui
    @checker = @activity_session.story_checker

    render layout: false
  end
end
