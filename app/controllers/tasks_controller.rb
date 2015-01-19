class TasksController < ApplicationController
	
	respond_to :html, :js

	def edit
		@task = Task.find(params[:id])
	end

	def create
		@task = Task.create(task_params)
		if @task.save
			flash[:success] = "Task is created!"
  	end
	end

	def update
		@task = Task.find(params[:id])
		if @task.update_attributes(task_params)
			flash[:success] = 'Task is updated!'
		end
	end

	def destroy
		@task = Task.find(params[:id])
		if @task.destroy
			flash[:success] = "Successefully destroyed task!"
		end
	end
	
	private 

		def task_params
			params.require(:task).permit(:name, :deadline)
		end

end
