class FortressController < ApplicationController
  layout "fortress"

  def dynamo_test
    render :action => 'dynamo_test', :layout => false
  end
end
