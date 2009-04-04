class Creation::AreaLinksController  < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @object.requisites = []
  end
end
