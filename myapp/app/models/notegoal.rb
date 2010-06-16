class Notegoal < ActiveRecord::Base
  belongs_to :note
  belongs_to :goal
end
