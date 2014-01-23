class Assessment < SimpleDelegator
  delegate :questions, to: :chunks

  def chunks
    @chunks ||= GrammarChunker.chunk(parsed)
  end

  def parsed
    @parsed ||= GrammarParser.new.parse(markdown(body.to_s))[:questions]
  end

  def as_json *args
    super.merge({
      rule_position: chapter.rule_position
    })
  end

  def as_json
    {
      body: body,
      id: _uid
    }
  end

  def id
    _uid
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
