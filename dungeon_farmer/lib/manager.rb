class Manager
  def initialize
    @active_tasks = []
    @inactive_tasks = []
    
    @target_cells = Set.new
  end
  
  def debug
    s = "#{to_s}\n"

    s << "  - Active Tasks (#{num_active}):\n"
    @active_tasks.each do |task|
      s << "    #{task.debug}\n"
    end
    
    s << "  - Inactive Tasks (#{num_inactive}):\n"
    @inactive_tasks.each do |task|
      s << "    #{task.debug}\n"
    end
    
    return s
  end
  
  def add_task(task)
    if @target_cells.include?(task.target_cell)
      task.cancel
    else
      @active_tasks.push task 
      @target_cells.add(task.target_cell)
    end
  end
  
  def get_task
    return @active_tasks.last
  end
  
  def deactivate_task
    return false unless @active_tasks.size > 0
    @inactive_tasks.push @active_tasks.pop
  end
  
  def activate_tasks(uncovered_cell)
    activate = []
    @inactive_tasks.reject! do |task|
      if task.can_perform_from uncovered_cell
        activate << task
        true
      else
        false
      end
    end
    
    @active_tasks.push(*activate)
  end
  
  def accomplish(task)
    task.accomplish
    @active_tasks.delete(task)
    @target_cells.delete(task.target_cell)
  end
  
  def cancel(task)
    task.accomplish
    @active_tasks.delete(task)
    @target_cells.delete(task.target_cell)
  end
  
  def all_tasks
    @active_tasks + @inactive_tasks
  end
  
  def num_active
    @active_tasks.size
  end
  
  def num_inactive
    @inactive_tasks.size
  end
end
