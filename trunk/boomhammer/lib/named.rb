module Named
  def self.included(model)
    model.class_eval do
      validates_presence_of :name
    end
  end

  def to_s
    name
  end
end
