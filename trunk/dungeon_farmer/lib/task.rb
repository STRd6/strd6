class Task
  attr_reader :target_cell, :perform_cells, :activity
  def initialize(target_cell, perform_cells, activity)
    @target_cell = target_cell
    @perform_cells = perform_cells
    @activity = activity
    
    @target_cell.add_task
  end
  
  def can_perform_from(cell)
    return @perform_cells.include?(cell)
  end
  
  def unblocked_cells
    return @perform_cells.select {|cell| !cell.blocked? }
  end
  
  def accomplish
    @target_cell.remove_task
  end
  
  def cancel
    @target_cell.remove_task
  end
end
