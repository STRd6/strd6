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
  
  def deactivate_task(task)
    if @active_tasks.include? task
      @active_tasks.delete task
      @inactive_tasks.push task
    end    
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

class MetricManager < Manager
  def initialize(owner)
    super()
    @owner = owner
    
    #TODO Define height and width more accurately, or even off-load metric
    @height = @width = 32
    
  end
  
  def get_task
    return @active_tasks.inject(nil) {|min, task| closest(min, task) }
  end
  
private
  def closest(t1, t2)
    return t2 unless t1 
    return t1 unless t2
    
    d1 = m_distance(@owner.x, @owner.y, t1.x, t1.y)
    d2 = m_distance(@owner.x, @owner.y, t2.x, t2.y)
    
    return t1 if d1 < d2
    return t2
  end
  
  def m_distance(x1, y1, x2, y2)
    x = (x1 - x2).abs
    y = (y1 - y2).abs
    [x, @width - x].min + [y, @height - y].min
  end
end