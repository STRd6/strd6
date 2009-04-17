class Creation::AreaBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  create.before do
    @area_base.account = current_account
  end

  protected

  def collection
    AreaBase.all :order => "name"
  end
end
