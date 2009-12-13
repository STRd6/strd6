module Treeworldly
  def self.included(model)
    model.class_eval do
      belongs_to :treeworld

      validates_presence_of :treeworld
    end
  end
end
