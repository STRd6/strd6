class Creation::AreaBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy
end
