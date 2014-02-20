class AddTimestampsToApplication < ActiveRecord::Migration
  def change
    add_timestamps :applications
  end
end
