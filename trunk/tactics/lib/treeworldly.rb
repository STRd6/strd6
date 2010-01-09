module Treeworldly
  def self.included(model)
    model.class_eval do
      belongs_to :treeworld

      validates_presence_of :treeworld

      delegate :width, :height, :wall_at, :to => :treeworld
    end
  end
end
