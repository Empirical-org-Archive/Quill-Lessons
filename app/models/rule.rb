class Rule < ActiveRecord::Base
  self.primary_key = 'id' # TODO remove this
  include Flags
  belongs_to :category
  belongs_to :workbook
  validates :name, presence: true
  has_many :examples, class_name: 'RuleExample'

  has_many :questions, class_name: 'RuleQuestion' do
    def unanswered score, step
      answered_ids = score.inputs.where(step: step).map(&:rule_question_id)
      return all if answered_ids.empty?
      where('id not in (?)', answered_ids.uniq)
    end
  end

  accepts_nested_attributes_for :examples
end
