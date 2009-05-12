class FortressController < ApplicationController
  layout "fortress"

  def test
    render :action => 'test', :layout => false
  end
end
