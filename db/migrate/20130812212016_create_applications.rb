class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :user, index: true
      t.string :resume
      t.string :essay_url
      t.string :video_url
      t.string :completed_steps
    end
  end
end
