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
    body = YAML.load(activity.data.body).gsub("\r\n", "<br>")

  end


  def parsed
    @parsed ||= GrammarParser.new.parse(YAML.load(activity.data.body))[:questions]
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

