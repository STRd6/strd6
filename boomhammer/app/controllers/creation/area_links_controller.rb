class Creation::AreaLinksController  < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @object.requisites = []
  end

  create.before do
    # Convert into language that the model can understand
    @object.create_inverse_link = false if @object.create_inverse_link == "0"
  end
end
