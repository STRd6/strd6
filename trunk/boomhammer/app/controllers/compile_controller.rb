class CompileController < ApplicationController
  layout false
  skip_before_filter :verify_authenticity_token

  def index
    
  end

  def test
    
  end

  def create
    tempfile = Tempfile.new('code', Rails.root)

    tempfile.puts params[:src]
    tempfile.close
    #render :text => "Wassup!"
    #render :text => params[:src].inspect
    render :text => `#{Rails.root + 'compile.rb'} < #{tempfile.path}`
    #render :text => "#{Rails.root + 'compile.rb'} #{tempfile.path}"
  end
end
