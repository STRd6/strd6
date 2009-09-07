# This module takes care of adding a random scope to records

module RandomScope
  def self.included(model)
    model.class_eval do
      if connection.adapter_name == "MySQL"
        named_scope :random, lambda { |amount|
          if(amount)
            {:order => "RAND()", :limit => amount}
          else
            {:order => "RAND()"}
          end
        }
      else
        named_scope :random, lambda { |amount|
          if(amount)
            {:order => "RANDOM()", :limit => amount}
          else
            {:order => "RANDOM()"}
          end
        }
      end
    end
  end
end
