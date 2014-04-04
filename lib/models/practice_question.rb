class PracticeQuestion < Quill::ActivityModel
  attributes :rule_position

  def rule_position_text= string
    self.rule_position = JSON.parse(string).map(&:strip)
  end

  def rule_position_text
    rule_position.to_json
  end

  def practice_rules
    rule_position.map{ |id| Rule.find(id) }
  end
end
