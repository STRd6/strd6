class IntrinsicBase < ActiveRecord::Base
  include Named

  belongs_to :image
end
