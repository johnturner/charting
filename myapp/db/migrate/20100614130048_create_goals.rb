class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.string :name
      t.string :status
      t.integer :admin

      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
