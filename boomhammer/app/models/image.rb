class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true

  validates_presence_of :file_name

  before_validation_on_create :generate_file_name

  after_create :save_file

  attr_accessor :file

  def image_file_name
    file_name
  end

  protected

  def generate_file_name
    self.file_name ||= Digest::SHA1.hexdigest("--#{rand(10000)}--#{Time.now}--")[0,16]
  end

  def save_file
    if file
      File.open("#{Rails.root}/public/production/images/#{file_name}", 'wb') do |f|
        f << Base64.decode64(file)
      end
    end
  end
end
