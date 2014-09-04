class Story < Quill::ActivityModel
  attributes :body, :instructions

  def assessment
    @assessment ||= Assessment.new(self)
  end

  def question_quantity_for_rule rule
    3
  end
end
