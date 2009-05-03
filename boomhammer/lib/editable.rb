module Editable
  enum :Editability do
    Public()
    Group()
    Owner()

    def self.default_string
      values.first.to_s
    end
  end

  def self.included(model)
    model.class_eval do
      belongs_to :account

      constantize_attribute :editability
      validates_inclusion_of :editability, :in => Editable::Editability.values

      validate :verify_editor
    end
  end

  attr_accessor :editor

  def editable_by(account)
    case editability
    when Editable::Editability::Owner
      self.account == account
    when Editable::Editability::Group
      true
    when Editable::Editability::Public
      true
    end
  end

  protected
  def verify_editor
    errors.add_to_base "#{editor} is not allowed to edit (#{editability})" unless editable_by editor
  end
end
