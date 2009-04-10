class Creation::ImageUploadController < ApplicationController
  def upload
    @image = Image.new
  end

  def process_upload
    image = Image.new(params[:image])
    image.width = 256
    image.height = 192

    if image.save
      flash[:notice] = "Successfully uploaded"
      redirect_to :controller => :images, :action => :show, :id => image.id
    else
      flash[:error] = "Failed to upload"
      redirect_to :upload
    end
  end
end
