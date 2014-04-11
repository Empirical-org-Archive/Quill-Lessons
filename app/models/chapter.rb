module ChapterView
  def story_instructions
    (assessment.instructions || default_story_instructions) % {errors: assessment.questions.length, max: 3}
  end

  def default_story_instructions
    'Proofread the story. There are %{errors} errors to correct. You may re-edit this essay %{max} times.'
  end
end

class Chapter < ActiveRecord::Base
  include ChapterView
  has_many :classroom_chapters
  has_many :scores, through: :classroom_chapters
  has_one :assessment
  belongs_to :workbook
  belongs_to :level, class_name: 'ChapterLevel', foreign_key: 'chapter_level_id'
  validates :title, presence: true
  validates :description, presence: true
  serialize :rule_position, Array
  accepts_nested_attributes_for :assessment
  default_scope -> { order(:title) }

  def rule_position_text= string
    self.rule_position = JSON.parse(string).map(&:strip)
  end

  def rule_position_text
    rule_position.to_json
  end

  def practice_rules
    rule_position.map{ |id| Rule.find(id) }
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def self.find id
    return super(id) if id.is_a?(Integer)
    return super(id) if id.to_s == id.to_i.to_s
    super(id.split('-').first)
  end
end
