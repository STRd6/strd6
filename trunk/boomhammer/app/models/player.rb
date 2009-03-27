class Player < ActiveRecord::Base
  belongs_to :account

  has_many :items, :as => :owner, :dependent => :destroy

  validates_presence_of :name
end
