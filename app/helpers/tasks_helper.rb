module TasksHelper
	
	private
	  	
	  def new_task
	  	if user_signed_in?
				@task = current_user.tasks.build(project_id: params[:project_id])
			end
		end	

end
