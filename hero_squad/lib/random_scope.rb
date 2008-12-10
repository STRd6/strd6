# This module takes care of adding a random scope to records

module RandomScope
  def self.included(recipient)
    recipient.class_eval do
      if connection.adapter_name == "MySQL"
        named_scope :random, :order => "RAND()"
      else
        named_scope :random, :order => "RANDOM()"
      end
    end
  end
end
