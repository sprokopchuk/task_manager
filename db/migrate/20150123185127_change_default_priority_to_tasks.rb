class ChangeDefaultPriorityToTasks < ActiveRecord::Migration
  def change
  	change_column_default( :tasks, :priority, 1)
  end
end
