class Chunk
  attr_reader :chapter, :chunk
  attr_accessor :state, :word, :error, :answer, :grammar, :text, :input

  delegate :rule, to: :@chunk
  delegate :classification, to: :rule

  class MissingChunkError < Exception ; end

  def initialize(chapter, options)
    @chapter = chapter
    @chunk   = chapter.assessment.chunks[options[:id]]

    raise MissingChunkError if @chunk.nil?

    %w(word error answer grammar text input).each do |k|
      instance_variable_set("@#{k}", options.fetch(k.to_sym, '').strip)
    end
  end

  def grade!
    @result ||= grade_calculator
  end

  def highlighted_word
    state == :missed ? correct : input
  end

  def input?
    (@input.blank? || word.blank?) ? false : !matches?(word)
  end

  def classification
    state == :introduced ? nil : rule.classification
  end

private
  def grade_calculator

    if matches?(correct)
      # matched the answer

      @state = word? ? nil : :found
      true

    elsif !input? && word?
      # no input, but expected answer

      @state = nil #:missed
      true
    else
      # new word, or got answer wrong

      @state = word? ? :introduced : :missed
      false
    end

  end

  def matches?(other)
    input == other
  end

  def word?
    !!word
  end

  def word
    chunk[:word]
  end

  def correct
    chunk[:answer].present? ? chunk[:answer] : chunk[:word]
  end
end
