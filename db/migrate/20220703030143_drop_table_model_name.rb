class DropTableModelName < ActiveRecord::Migration[7.0]
  def change
    drop_table :things
  end
end
