class AddParentToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :parent_id, :integer
  end

  def self.down
    remove_column :notes, :parent_id
  end
end
