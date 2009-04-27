class Image < ActiveRecord::Base
  include Votable
  
  acts_as_taggable_on :tags
  
  belongs_to :imageable, :polymorphic => true
  belongs_to :account

  validates_presence_of :file_name

  before_validation_on_create :generate_file_name

  after_create :save_file

  attr_accessor :file
  attr_accessor :upload

  default_scope :order => '`images`.up_votes_count - `images`.down_votes_count DESC, `images`.id'

  named_scope :small, :conditions => {:width => 32, :height => 32}
  named_scope :large, :conditions => {:width => 256, :height => 192}

  def self.remove_offensive
    offensive_images = Image.tagged_with "offensive", :on => :tags

    offensive_images.each do |image|
      image.deal_with_offenses
    end
  end

  def image
    self
  end

  def json_data
    image_data = Magick::Image.read(file_path).first

    return image_data.get_pixels(0, 0, width, height).map do |pixel|
      #TODO: Handle full range of alpha
      if pixel.opacity == 0
        pixel.to_color(Magick::AllCompliance, false, 8, true)
      else
        nil
      end
    end
  end

  def deal_with_offenses
    return unless over_offensive_threshold

    if(account = image.account)
      account.add_offense
    end

    image.move_image_file_to_deleted
    image.destroy
  end

  def over_offensive_threshold
    up_votes_count - down_votes_count <= -2
  end

  protected

  def generate_file_name
    self.file_name ||= Digest::SHA1.hexdigest("--#{rand(10000)}--#{Time.now}--")[0,16]
  end

  def save_file
    if file
      File.open(file_path, 'wb') do |f|
        f << Base64.decode64(file)
      end
    elsif upload
      File.open(file_path, 'wb') do |f|
        f << upload.read
      end
    end
  end

  def file_path
    "#{Rails.root}/public/production/images/#{file_name}"
  end

  def deleted_file_path
    "#{Rails.root}/public/production/images/#{file_name}_DELETED"
  end

  def move_image_file_to_deleted
    FileUtils.mv file_path, deleted_file_path
  end
end
