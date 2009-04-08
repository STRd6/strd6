class Creation::IntrinsicsController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  protected

  def collection
    Intrinsic.all :order => "name"
  end
end