class AddDescriptionToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :description, :text
  end

  def self.down
    remove_column :goals, :description
  end
end

