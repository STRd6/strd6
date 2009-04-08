class Creation::AreaBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  protected

  def collection
    AreaBase.all :order => "name"
  end
end
