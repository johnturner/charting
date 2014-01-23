class AddMajorToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :major, :boolean, :default => true
  end

  def self.down
    remove_column :notes, :major
  end
end
