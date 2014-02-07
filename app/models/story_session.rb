module RuleQuestionInputAccessors
  extend ActiveSupport::Concern

  %w(practice review).each do |step|
    define_method "#{step}_step_input=" do |hash|
      raise 'cannot be greater than 1' if hash.length > 1
      question, input = hash.first
      inputs.find_or_create_by(step: step, rule_question_id: question).handle_input(input)
    end
  end
end

class StorySession < Quill::ActivitySession
  attributes :story_step_input, :missed_rules
  include RuleQuestionInputAccessors

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
    raise 'requires id' if id.blank?
    RuleQuestionInput.where(activity_session_id: id)
  end

  def missed_rule_records(context)
    calculate_missed_rules(context) if missed_rules.blank? || missed_rules.empty?
    missed_rules.uniq.map{ |id| Rule.find(id) }
  end

  def calculate_missed_rules(context)
    checker = StoryChecker.new(self)
    checker.context = context
    self.missed_rules = checker.section(:missed).chunks.map { |c| c.rule.id }
  end
end
