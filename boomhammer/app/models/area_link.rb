class AreaLink < ActiveRecord::Base
  include Requisite

  belongs_to :area
  belongs_to :linked_area, :class_name => "Area"

  after_create :create_inverse_link!

  attr_accessor :create_inverse_link

  protected
  # Adds an additional link representing the inverse connection
  # Together they form a bi-directional link
  # The other link has the same attributes as this one except with the
  # direction reversed.
  def create_inverse_link!
    if create_inverse_link
      AreaLink.create! attributes.merge(
        :area => linked_area,
        :linked_area => area,
        :create_inverse_link => false
      )
    end
  end
end
