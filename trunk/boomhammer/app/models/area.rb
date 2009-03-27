class Area < ActiveRecord::Base
  belongs_to :area_base

  has_many :area_links, :dependent => :destroy
  has_many :incoming_links, :foreign_key => :linked_area_id, :dependent => :destroy
  has_many :items, :as => :owner, :dependent => :destroy
  has_many :opportunities, :dependent => :destroy

  validates_presence_of :area_base
  validates_presence_of :name
end
