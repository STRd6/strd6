class Intrinsic < ActiveRecord::Base
  include Named
  include Imageable

  def self.basic
    [
      "charisma", "see invisible", "flight",
      "fire resistance", "cold resistance", "stench resistance",
    ]
  end

  def self.sanitize(intrinsic_array)
    valid_intrinsics = Intrinsic.all.map(&:name)
    return intrinsic_array.select {|e| valid_intrinsics.include? e}
  end

  def self.legit?(intrinsic)
    Intrinsic.all.map(&:name).include?(intrinsic)
  end
end
