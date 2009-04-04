class Creation::AreasController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy
end
