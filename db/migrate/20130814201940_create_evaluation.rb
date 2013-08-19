class CreateEvaluation < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.string :title
      t.string :slug
      t.references :user, index: true
      t.references :application, index: true
      t.timestamp :completed_at
      t.timestamps
    end
  end
end
