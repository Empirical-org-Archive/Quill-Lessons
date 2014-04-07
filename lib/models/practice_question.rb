class PracticeQuestion < Quill::ActivityModel
  attributes :rule_position

  def rule_position_text= string
    array = string.flatten if string.is_a? Array

    array ||= JSON.parse(string).map do |item|
      if item.respond_to?(:strip)
        item.strip
      else
        item
      end
    end

    self.rule_position = array
  end

  def rule_position_text
    rule_position.to_json
  end

  def practice_rules
    rule_position.map{ |id| Rule.find(id) }
  end
end
