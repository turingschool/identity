class ApplicationsCanBeHidden < ActiveRecord::Migration
  def change
    add_column :applications, :hide_until_active, :boolean, default: false
    add_column :applications, :permahide,         :boolean, default: false
  end
end
