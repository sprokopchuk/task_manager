class ProjectsController < ApplicationController

	def create
		@project = Project.create(project_params)
	end

	def index
		@projects = Project.all
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
