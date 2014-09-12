class RemoveDeadTables < ActiveRecord::Migration
  def change
    drop_table :grammar_rules
    drop_table :grammar_tests
    drop_table :rules_misseds
  end
end
