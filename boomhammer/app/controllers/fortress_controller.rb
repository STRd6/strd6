class FortressController < ApplicationController
  layout "fortress"

  def dynamo_test
    render :action => 'dynamo_test', :layout => false
  end

  def adjustable_queue_test
    render :action => 'adjustable_queue_test', :layout => false
  end

  def priority_queue_test
    render :action => 'priority_queue_test', :layout => false
  end

end
