class Story < Empirical::Client::Endpoints::Activity

  # attributes :body, :instructions

  attr_accessor :chunks, :parsed

  def assessment
    self
  end

  def chunks
    @chunks ||= GrammarChunker.chunk(parsed)
  end
  delegate :questions, to: :chunks

  def body_parser
    body = YAML.load(activity.data.body).gsub("\n", "<br>").html_safe
  end

  # for form_for etc
  def self.model_name
    ActiveModel::Name.new(Story)
  end


  def parsed
    @parsed ||= GrammarParser.new.parse(body_parser)[:questions]
  end

  def question_quantity_for_rule rule
    3
  end

  def as_json
    {
      body: YAML.load(activity.data.body),
      id: id
    }
  end

  def to_json
    as_json.to_json
  end

end

