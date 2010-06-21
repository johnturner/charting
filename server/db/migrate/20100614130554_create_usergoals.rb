class CreateUsergoals < ActiveRecord::Migration
  def self.up
    create_table :usergoals do |t|
      t.references :user
      t.references :goal

      t.timestamps
    end
  end

  def self.down
    drop_table :usergoals
  end
end
