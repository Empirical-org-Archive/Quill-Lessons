module RuleQuestionInputAccessors
  extend ActiveSupport::Concern

  %w(practice review).each do |step|
    define_method "#{step}_step_input=" do |hash|
      send "#{step}_handle_input", hash, nil
    end

    define_method "#{step}_handle_input" do |hash, input_step|

      raise 'cannot be greater than 1' if hash.length > 1
      question, input = hash.first
      inputs.find_or_create_by(step: step, rule_question_id: question).handle_input(input, cast_input_step(input_step))
    end
  end

  def cast_input_step input_step
    if input_step.to_s == 'first'
      :first
    elsif input_step.to_s == 'second'
      :second
    elsif input_step.nil?
      nil
    else
      raise 'unacceptable value for cast_input_step'
    end
  end
end

class StorySession < Empirical::Client::Endpoints::ActivitySession

  include RuleQuestionInputAccessors

  attr_accessor :activity, :submission, :story_checker

  def activity
    @activity ||= Story.find(activity_uid)
  end

  def activity_uid
    activity_session.present? ? activity_session.activity_uid : self['activity_uid']
  end

  def uid
    activity_session.present? ? activity_session.uid : self['uid']
  end

  def start!
    self.state = "started"
  end

  def check_submission(input)
    self.story_step_input = input.map { |x| Hashie::Mash.new(x) }

    @story_checker = StoryChecker.new(activity, input)
    @story_checker.grade!
  end


# old methods
  def unstarted?
    false
  end

  def story?
    false
  end

  def practice?
    false
  end

  def review?
    true
  end

  def chapter_state
    'review'
  end

  def inputs
    if activity_session.try(:uid).blank?
      Raven.extra_context :story_session, self
      raise "some kind of hell"
    end
    RuleQuestionInput.where(activity_session_id: activity_session.uid)
  end

  def missed_rule_records
    calculate_missed_rules if missed_rules.blank? || missed_rules.empty?
    missed_rules.uniq.map{ |id| Rule.find(id) }
  end

  def calculate_missed_rules
    Raven.extra_context :story_session, self

    if !self.activity_session.nil? && !self.activity_session.data.nil?
      input = YAML.load(activity_session.data.story_step_input)
    elsif self.data.present?
      input = data.story_step_input
    end

    checker = StoryChecker.new(activity, input)
    checker.grade!

    self.missed_rules = checker.section(:missed).chunks.map { |c| c.rule.id }
  end

  def finalize!
    # self.score_values = ScoreFinalizer.new(self).results
    self.completed_at ||= Time.now
    self.state = 'finished'

    self.percentage = (inputs.size == 0) ? 1.0 : inputs.map(&:score).inject(:+) / inputs.count

    save
  end
end
