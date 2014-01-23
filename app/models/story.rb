class Story < Quill::ActivityModel
  attributes :name, :description, :body, :instructions
  validates :name, presence: true
  validates :description, presence: true
end
