class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :chapters, :rule_position

    add_index :rule_question_inputs, :activity_session_id
    add_index :rule_question_inputs, :score_id
    add_index :rule_question_inputs, :rule_question_id

    add_index :rule_examples, :rule_id
    add_index :rule_questions, :rule_id

    add_index :rules, :category_id
  end
end
