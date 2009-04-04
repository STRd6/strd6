class Creation::OpportunitiesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy
end
