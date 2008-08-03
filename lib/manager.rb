class Manager
  def initialize
    @active_tasks = []
    @inactive_tasks = []
  end
  
  def add_task(task)
    if @active_tasks.any? { |t| t.target_cell == task.target_cell }
      task.cancel
    else
      @active_tasks.push task 
    end
  end
  
  def add_inactive_task(task)
    @inactive_tasks.push task
  end
  
  def get_task
    return @active_tasks.last
  end
  
  def deactivate_task
    return nil unless @active_tasks.size > 0
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
  end
  
  def num_active
    @active_tasks.size
  end
  
  def num_inactive
    @inactive_tasks.size
  end
end
