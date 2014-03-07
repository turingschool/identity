class AddStatusToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :status, :string, default: 'pending'
  end
end
