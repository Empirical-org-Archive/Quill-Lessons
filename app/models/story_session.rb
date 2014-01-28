class StorySession < Quill::ActivitySession
  attributes :story_step_input, :missed_rules

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
    RuleQuestionInput.where(activity_session_id: _uid)
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
