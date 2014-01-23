class Usergoal < ActiveRecord::Base
  belongs_to :user
  belongs_to :goal
end
