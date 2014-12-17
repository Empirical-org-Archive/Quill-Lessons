class Chapter::PracticeController < Chapter::BaseController

  before_action :find_rule,          except: ['cheat', 'verify', 'verify_status']
  before_action :update_progress,    except: ['cheat', 'verify', 'verify_status', 'index']

  skip_before_action :find_assignment, only: ['cheat']
  prepend_before_action :clean_step_param

  rescue_from(FlowError) { display_flow_error_message }

  def show
    if params[:question_index].blank?
      # FIXME: What is params step ID and why is this dynamic parameter everywhere?
      params[:"#{params[:step]}_id"] = params.delete(:id)
      params[:question_index] = 1
      redirect_to url_for(params.merge(id: nil))
      return
    end

    # FIXME: practice! method not defined anywhere
    @activity_session.practice! if @activity_session.unstarted?
  end

  def index
    chapter_step = @chapter_test.step(params[:step].to_sym)
    Rails.logger.info "chap step... #{chapter_step.inspect} ... rules: #{chapter_step.rules.inspect}"
    redirect_to send("chapter_#{params[:step]}_path", @chapter.id, chapter_step.rules.first.id)
  end

  def verify
    update_score
    # FIXME: Duplicated in verify_status.
    input = @activity_session.inputs.where(step: params[:step], rule_question_id: params[:lesson_input].first.first).first
    render json: input.as_json(methods: [:first_grade, :second_grade])
  end

  def verify_status
    input = @activity_session.inputs.where(step: params[:step], rule_question_id: params[:lesson_input].first.first).first
    render json: input.as_json(methods: [:first_grade, :second_grade])
  end

  def cheat
    @activity_session = StorySession.find(params[:score_id])
    render json: { answer: RuleQuestion.find(params[:lesson_input].first.first).answers.first }
  end

protected

  def find_rule
    return true if (params[:id] || params[:"#{params[:step]}_id"]).blank?
    @rule   ||= Rule.joins(:questions).find(params[:id] || params[:"#{params[:step]}_id"])
    @question = @rule.questions.unanswered(@activity_session, params[:step]).sample
    # too unpredictable.. please go where you need to will not infer
    return redirect_to @chapter_test.send :next_rule_url if @question.blank?
    raise FlowError, "Attempted to retrieve a question, but there are no more. Total number of questions available is #{@rule.questions.count}" if @question.blank?
  end

  def clean_step_param
    unless %w(practice review).include? params[:step]
      raise 'invalid step'
    end
  end

private

  def display_flow_error_message
    slack_debug("FlowError Rescued.", {title: "Chapter Diagnostics", value: @chapter_test.diagnostics.awesome_inspect({plain: true}), short: false})
    render template: 'chapter/base/flow_error_message'
  end

  def update_score
    @activity_session.send lesson_input_key, params[:lesson_input], params[:input_step]
    @activity_session.save
  end

  def lesson_input_key
    :"#{params[:step]}_handle_input"
  end

  def update_progress
    return unless @rule.present?
    raise FlowError if @chapter_test.current_step.rules.empty?

    @questions_completed = @chapter_test.questions_completed
    @questions_total     = @chapter_test.questions_total
  end
end
