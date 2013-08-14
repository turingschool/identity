class CreateEvaluation < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.references :user, index: true
      t.references :application, index: true
      t.timestamps
    end
  end
end
