class PracticeQuestion < Empirical::Client::Endpoints::Activity

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

  def rule_position
    x = activity.nil? ? self['rule_position'] : activity.data.rule_position
    x.kind_of?(String) ? YAML.load(x) : x
  end

  def rule_position_text
    rule_position.to_json
  end

  def practice_rules
    return [] if rule_position.nil?

    ids = if rule_position.first.is_a?(Array)
      rule_position.map(&:first)
    else
      rule_position
    end

    ids.map{ |id| Rule.find(id) }
  end

  def question_quantity_for_rule rule
    rule_position.each do |pair|
      id, count = pair
      return (count.presence.try(:to_i) || 3) if id.to_i == rule.id
    end

    raise "couldn't find rule id #{rule.id} for question set #{id}"
  end
end