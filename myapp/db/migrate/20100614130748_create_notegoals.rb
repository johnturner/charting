class CreateNotegoals < ActiveRecord::Migration
  def self.up
    create_table :notegoals do |t|
      t.references :note
      t.references :goal

      t.timestamps
    end
  end

  def self.down
    drop_table :notegoals
  end
end
