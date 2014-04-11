module ChapterFlow
  def next_page_url
    fix_id_param

    # if the score is unstarted proceed to practice step.
    result = if score.unstarted?
      score.practice!
      @context.chapter_practice_index_path(chapter)

    # we are on one of the two practice steps and we have
    # the id of the practice question.
    elsif params[:step].present? && params[step_id_key].present?
      load_url_from_params

    # Check to see if they are on the story step currently
    elsif score.story?
      @context.chapter_story_path(chapter)

    # Let's try filling out the step information and retrying with the additional parameters.
    elsif (score.practice? || score.review?)
      params[:step] = score.chapter_state
      params[:question_index] = score.inputs.where(step: params[:step]).count

      # Proceed to to the next step if they are on the review step and
      # there are now review rules (i.e. the user got 100% on the story)
      if score.review? && step(params[:step].to_sym).rules.empty?
        next_rule_url
      else
        params[step_id_key] = step(params[:step].to_sym).rules.first.id
        load_url_from_params
      end

    # Finally, just proceed to the next step.
    else
      next_rule_url
    end

    # It should never generate a URL with a query string
    raise result.to_s if result.include?('?')
    result
  end

  def questions_completed
    rules = current_step.rules.map(&:rule)
    rules = rules.select{|rule| rules.index(rule) < rules.index(current_rule)}
    questions_total(rules) + @context.params[:question_index].to_i
  end

  def questions_total rules = false
    (rules || current_step.rules).inject(0) {|sum, rule| sum + chapter.question_quantity_for_rule(rule)}
  end

  def question_quantity_for_current_rule
    chapter.question_quantity_for_rule(current_rule)
  end

protected

  def step_id_key
    :"#{params[:step]}_id"
  end

  # standardize params. params[:id] is too ambiguous
  def fix_id_param
    return (id = params.delete(:id)).present?

    if params[:step].present?
      params[step_id_key] = id
    else
      params[:chapter_id] = id
    end
  end

  def load_url_from_params
    # Is there another question for this rule? If so, go to that.
    if next_index.present?
      @context.url_for(
        controller: 'practice',
        action: 'show',
        chapter_id: params[:chapter_id],
        step_id_key => params[step_id_key],
        question_index: next_index,
        step: params[:step]
      )

    # there is no more questions for this rule. Proceed to whatever comes next
    # possibly a rule, or the next step. Possibly break this logic out? Seems
    # strange to hide it in a method misleadingly named #next_rule_url
    else
      next_rule_url
    end
  end

  # proceed to next rule in the step, or go to the next step if there are no
  # more rules.
  def next_rule_url
    if next_rule_id.present?
      @context.send("chapter_#{params[:step]}_path", chapter.id, next_rule_id)
    else
      step_after_rules_completed
    end
  end

  # this is the actual business logic for where to go next. It also updates
  # the state of the score accordingly.
  def step_after_rules_completed
    @context.chapter_final_path(chapter.id)
  end

  def next_index
    params[:question_index].to_i + 1 if params[:question_index].to_i < question_quantity_for_current_rule
  end

  def question_quantity_for_current_rule
    chapter.question_quantity_for_rule(current_rule)
  end

  def next_rule_id
    next_rule.try(:id)
  end

  def next_rule
    return if params[:step].blank?
    step(params[:step].to_sym).next_rule
  end
end

class ChapterTest
  delegate :params, to: :@context
  include ChapterFlow

  def initialize context
    @context = context
  end

  def current_step
    step(current_step_symbol)
  end

  def current_step_symbol
    if params[:controller] == "chapter/stories"
      :story
    elsif params[:step] == "practice"
      :practice
    elsif params[:step] == "review"
      :review
    elsif params[:action] == "final"
      :final
    else
      raise 'unknown step.'
    end
  end

  def current_rule
    @context.instance_variable_get(:@rule)
  end

  def steps
    [:practice, :story, :review].map{ |s| Step.new(s, self) }
  end

  def step step
    steps.find{ |s| s.step == step }
  end

  def chapter
    @context.instance_variable_get(:@chapter)
  end

  def score
    @context.instance_variable_get(:@score)
  end

  def diagnostics
    {
      rule_count: current_step.rules.length,
      rule_question_counts: current_step.rules.map { |r| r.rule.questions.count },
      step: current_step_symbol,
      state: score.state
    }
  end

  class Step
    attr_reader :step
    delegate :current_step, :current_rule, :chapter, :score, to: :@context

    def initialize step, context
      @step = step
      @context = context
    end

    def css_class
      if current_step?
        "#{step} current"
      else
        "#{step} not-current"
      end
    end

    def title
      I18n.t(:title, scope: :"chapter_test_step.#{step}")
    end

    def current_step?
      current_step.step == step
    end

    def rules
      res = case step
      when :practice
        chapter.practice_rules
      when :story
        []
      when :review
        score.missed_rule_records(@context.instance_variable_get(:@context))
      end

      res.map{ |r| Rule.new(r, self) }
    end

    def next_rule
      return false if rules.map(&:rule).index(current_rule).blank?
      rules[rules.map(&:rule).index(current_rule) + 1]
    end

    def inputs_for rule
      score.inputs.where(step: step).joins(:rule).where(rules: { id: rule.id })
    end
  end

  class Rule
    attr_reader :rule

    delegate :title, :id, to: :rule
    delegate :chapter_test, to: :@step
    delegate :current_rule, to: :chapter_test

    def initialize rule, step
      @rule = rule
      @step = step
    end

    def css_class
      if current_rule? then 'current-rule' else '' end
    end

    def current_rule?
      current_rule == rule
    end

    def inputs
      @step.inputs_for(rule)
    end

    def correct_count
      inputs.select(&:first_grade).length
    end

    def second_try_count
      inputs.select(&:second_grade).length
    end

    def missed_count
      inputs.select(&:missed?).length
    end
  end
end
