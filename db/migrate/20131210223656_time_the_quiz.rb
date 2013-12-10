class TimeTheQuiz < ActiveRecord::Migration
  def change
    add_column :applications, :quiz_started_at, :timestamp
    add_column :applications, :quiz_completed_at, :timestamp
  end
end
