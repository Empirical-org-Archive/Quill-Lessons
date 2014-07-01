class Category < ActiveRecord::Base
  self.primary_key = 'id' # TOD remove this
  has_many :rules

  def mutable?
    true
  end
end
