class AreaLink < ActiveRecord::Base
  include Requisite

  belongs_to :area
  belongs_to :linked_area, :class_name => "Area"
end
