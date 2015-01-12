class ProjectsController < ApplicationController

	respond_to :html, :js

	def new
		@project = Project.new
	end
	
	def create
		@project = Project.create(project_params)
		if @project.save
			flash[:success] = "Project is created!"
  	else
  		render :new
  	end
	end

	def index
		@projects = Project.all
		@task = Task.new(project_id: params[:project_id])
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
	end

	def destroy
	end

private
	
	def project_params
		params.require(:project).permit(:name)
	end	

end
