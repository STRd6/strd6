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

  def image
    self
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
end
