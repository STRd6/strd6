module FacilityHelper
  def notifications
    render :partial => 'components/notifications'
  end

  def prototype_submit(text="Submit")
    link_to_function text, "$(this).up('form').submit()"
  end
end