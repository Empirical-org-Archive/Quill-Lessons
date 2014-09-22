class Story < Empirical::Client::Endpoints::Activity

  # attributes :body, :instructions

  attr_accessor :chunks, :parsed

  def uid
    activity.present? ? activity.uid : self['uid']
  end
  alias_method :id, :uid

  def instructions_as_text
    YAML.load(activity.data['instructions']) if activity.present?
  end

  def body_as_text
    YAML.load(activity.data['body']) if activity.present?
  end

  def assessment
    self
  end

  def chunks
    @chunks ||= GrammarChunker.chunk(parsed)
  end
  delegate :questions, to: :chunks

  def body_parser
    body = YAML.load(activity.data.body.to_s).gsub("\n", "<br>").html_safe
  end

  # for form_for etc
  def self.model_name
    ActiveModel::Name.new(Story)
  end

  def as_display_json
    {
      body: YAML.load(activity.data.body),
      id: id
    }.to_json
  end

  def parsed
    @parsed ||= GrammarParser.new.parse(body_parser)[:questions]
  end

  def question_quantity_for_rule rule
    3
  end

end

