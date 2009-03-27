class AreaLink < ActiveRecord::Base
  belongs_to :area
  belongs_to :linked_area
end
