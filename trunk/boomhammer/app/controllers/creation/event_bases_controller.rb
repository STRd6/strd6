class Creation::EventBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  protected

  def collection
    EventBase.all :order => "name"
  end
end
