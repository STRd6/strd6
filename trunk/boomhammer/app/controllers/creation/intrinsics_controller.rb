class Creation::IntrinsicsController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy
end