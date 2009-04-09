class Creation::IntrinsicBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  protected

  def collection
    IntrinsicBase.all :order => "name"
  end
end