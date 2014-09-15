class StoryChecker < SimpleDelegator

  attr_accessor :submission_steps, :context

  def initialize(activity, input=[])
    input = [] if input.nil?
    @submission_steps = input.map {|c| Chunk.new(activity, c) }
  end

  def grade!
    @submission_steps.each(&:grade!)
  end

  def check_input!(input, saving = true)
    @chunks = input.map { |c| Chunk.new(activity, c) }.each(&:grade!)
  end

  def chunks
    @submission_steps
  end

  def chapter_test
    context.instance_variable_get(:@context)
  end

  def title
    if (found = sections.find{ |s| s.section == :found }.results).any?
      "You Found #{found.count} #{'Error'.pluralize(found.count)}!"
    else
      'You didn\'t find any errors.'
    end
  end

  def sections
    [:missed, :found, :introduced].map { |s| Section.new(self, s) }
  end

  def section section
    sections.find { |s| s.section == section }
  end


  class Section
    attr_reader :checker, :section

    def initialize checker, section
      @checker = checker
      @section = section
    end

    def results
      checker.submission_steps.select { |c| c.state == section }
    end
    alias :chunks :results

    def title
      "#{results.count} #{title_word} #{'Problem'.pluralize(results.count)}"
    end

    def css_class
      section.to_s
    end

    def title_word
      case section
      when :missed     then 'Unsolved'
      when :found      then 'Solved'
      when :introduced then 'Introduced'
      else
        raise "invalid section type: #{section.inspect}"
      end
    end
  end
end
