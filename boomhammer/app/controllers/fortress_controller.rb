class FortressController < ApplicationController
  layout "fortress"

  def test
    render :action => 'test', :layout => false
  end

  def engine_test
    render :action => 'engine_test', :layout => false
  end
end
