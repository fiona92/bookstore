class DropTableGenres < ActiveRecord::Migration
  def up
    drop_table :genres
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end