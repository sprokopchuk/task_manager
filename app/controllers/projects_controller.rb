class ProjectsController < ApplicationController

	before_action :new_task, only: [:index, :create]

	respond_to :html, :js
	
	def new
		@project = Project.new
	end
	
	def create
		@project = Project.create(project_params)

  	if @project.save
      flash.now[:info] = "Project created!"
    end
	end

	def index
		@projects = Project.all
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])
		if @project.update_attributes(project_params) 
      flash.now[:success] = "Project updated!"
    end
	end

	def destroy
		@project = Project.find(params[:id])
		if @project.destroy
			flash.now[:success] = "Project and dependent tasks are destroyed!"
		end
	end

private
	
	def project_params
		params.require(:project).permit(:name)
	end

	def new_task
		@task = Task.new(project_id: params[:project_id])
	end	

end
