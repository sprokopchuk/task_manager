class TasksController < ApplicationController
	
	respond_to :html, :js

	def edit
		@task = Task.find(params[:id])
	end

	def create
		@task = Task.create(task_params)
		if @task.save
			flash.now[:success] = "Task is created!"
  	end
	end

	def update
		@task = Task.find(params[:id])
		if @task.update_attributes(task_params)
			flash.now[:success] = 'Task is updated!'
		end
	end

	def destroy
		@task = Task.find(params[:id])
		if @task.destroy
			flash.now[:success] = "Successefully destroyed task!"
		end
	end

	def done
		@task = Task.find(params[:id])
		if @task.update_attributes(:done => params[:done])
			flash.now[:success] = 'This task is done!'
		end
	end
	
	def priority
		@task = Task.find(params[:id])
		priority_value = @task.priority
		if params[:priority] == 'up'
			priority_value = priority_value.next unless @task.priorities[priority_value.next].nil?
		elsif params[:priority] == 'down'
			priority_value = priority_value.pred unless @task.priorities[priority_value.pred].nil?
		end

		@task.update_attributes(:priority => priority_value) unless priority_value.nil?
	end

	private 

		def task_params
			params.require(:task).permit(:name, :deadline, :project_id)
		end


end
