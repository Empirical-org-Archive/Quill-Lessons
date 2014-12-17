class Chapter::StoriesController < Chapter::BaseController

  def show
    @assessment = @chapter.assessment
    @body_class = 'con-skyblue'
  end

  def create
    if defined?(Raven)
      Raven.extra_context(params: params)
      Raven.extra_context(session: session.to_hash)
      Raven.extra_context(activity_session: @activity_session)
    end
    # do some error handling if bad data presented
    if params[:_json].blank?
      render layout: false and return
    end

    @activity_session.start!
    @activity_session.check_submission(params[:_json])
    @activity_session.anonymous! if session[:anonymous]

    @activity_session.save
    session[:activity_session_id] = @activity_session.activity_session.uid

    # sugar, for ui
    @checker = @activity_session.story_checker

    # FIXME: Why no layout here, but there are some layouts that seem to be used elsewhere
    render layout: false
  end
end
