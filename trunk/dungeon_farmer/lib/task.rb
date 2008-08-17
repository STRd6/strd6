class Task
  attr_reader :target_cell, :perform_cells, :activity, :over
  def initialize(target_cell, perform_cells, activity)
    @target_cell = target_cell
    @perform_cells = perform_cells
    @activity = activity
    
    @target_cell.add_task
    
    @over = false
  end
  
  def debug
    s = "     #{@activity} => #{@target_cell} | #{@over}"
  end
  
  def can_perform_from(cell)
    return @perform_cells.include?(cell)
  end
  
  def unblocked_cells
    return @perform_cells.select {|cell| !cell.blocked? }
  end
  
  def accomplish
    @target_cell.remove_task unless @over
    @over = true
  end
  
  def cancel
    @target_cell.remove_task unless @over
    @over = true
  end
end
