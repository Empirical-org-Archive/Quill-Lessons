class InitSchema < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute(File.read('./db/quill_schema.sql'))
  end
end
