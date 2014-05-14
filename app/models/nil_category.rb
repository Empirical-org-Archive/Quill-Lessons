module NilCategory

  def title
    "Rules without a category"
  end

  def mutable?
    false
  end

  def rules
    Rule.where('category_id is null')
  end

  def model_name
    ActiveModel::Name.new(Category)
  end

  def class
    self
  end

  def id
    'nil'
  end

  extend self
end
