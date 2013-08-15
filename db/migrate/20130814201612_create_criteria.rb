class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
      t.references :evaluation, index: true
      t.string :title
      t.text :notes
      t.text :options
      t.integer :score
      t.timestamps
    end
  end
end
