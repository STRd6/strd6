class Creation::AreaLinksController  < ResourceController::Base
  actions :all, :except => :destroy

  new_action.before do
    @object.requisites = []
  end
end
