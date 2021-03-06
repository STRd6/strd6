class Area < ActiveRecord::Base
  include Named
  include RandomScope
  
  belongs_to :area_base
  belongs_to :region

  has_many :area_links, :dependent => :destroy
  has_many :linked_areas, :through => :area_links, :class_name => 'Area'

  has_many :incoming_links, :foreign_key => :linked_area_id, :dependent => :destroy
  has_many :items, :as => :owner, :dependent => :destroy
  has_many :opportunities, :dependent => :destroy
  has_many :shops, :dependent => :destroy

  has_one :image, :through => :area_base

  validates_presence_of :area_base, :region

  named_scope :starting, :conditions => {:starting_location => true}

  accepts_nested_attributes_for :opportunities, :allow_destroy => true

  delegate :description, :to => :area_base

  # Returns self
  def add_bi_directional_link_to(area, attributes={})
    area.area_links << AreaLink.new(attributes.merge(:linked_area => self))
    area_links << AreaLink.new(attributes.merge(:linked_area => area))

    return self
  end

  # Returns self
  def add_opportunity(attributes={})
    opportunities << Opportunity.new(attributes)

    return self
  end
end
