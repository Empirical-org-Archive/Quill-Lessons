class Story < Empirical::Client::Endpoints::Activity

  endpoint_name "activities"

  attributes :body, :instructions

  attr_accessor :chunks, :parsed

  def assessment
    self
  end

  def chunks
    @chunks ||= GrammarChunker.chunk(parsed)
  end
  delegate :questions, to: :chunks

  def parsed
    @parsed ||= GrammarParser.new.parse(activity.data.body)[:questions]
  end

  def question_quantity_for_rule rule
    3
  end

  def as_json
    {
      body: activity.data.body,
      id: id
    }
  end

  def to_json
    as_json.to_json
  end

  private

  def markdown text
    # fake markdown
    text.gsub("\n", "<br>").html_safe
  end
end

