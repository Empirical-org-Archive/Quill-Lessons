module ApplicationHelper
  # overrides for form_for.
  #
  # === Options
  # [:layout]
  #   Choose a bootstrap layout. Options are vertical, inline and horizontal.
  #   Defaults to horizontal.
  # [:class]
  #   Add a css class to the chosen layout class.
  def form_for *args, &block
    options = args.extract_options!

    layout = case options.delete(:layout)
    when 'vertical' then 'form-vertical'
    when 'inline' then 'form-inline'
    else
      'form-horizontal'
    end

    # this allows us to do form_for(object, class: 'form-class')
    # rather than form_for(object, html: { class: 'form-class' })
    if css_class = options.delete(:class)
      layout << " #{css_class}"
    end

    args << options.reverse_merge(builder: EgFormBuilder, format: 'html', html: {class: layout})
    super *args, &block
  end

  def body_class
    @body_class
  end

  def body_id
    @body_id
  end

  def root_path
    root_url
  end

  def as_markdown(text)
    Kramdown::Document.new(text).to_html.html_safe
  end
end
