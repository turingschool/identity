class CreateRemoteClients < ActiveRecord::Migration
  def change
    create_table :remote_clients do |t|
      t.string :name
      t.string :secret
    end
  end
end
