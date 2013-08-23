class AddQuizToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :quiz_questions, :text
    add_column :applications, :quiz_answers, :text
  end
end
