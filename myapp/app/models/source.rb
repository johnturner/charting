class Source < ActiveRecord::Base
  def to_s
    title
  end
end
