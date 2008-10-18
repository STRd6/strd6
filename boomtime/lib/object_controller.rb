module ObjectController
  def self.included(base)
    base.class_eval do
      before_filter :login_required
      actions :all, :except => [:destroy]

      create.before do
        object.creator = active_character
        object.area = active_character.area if active_character
      end
    end
  end
end
