class SessionsController < Devise::SessionsController  
	
	include TasksHelper
	include ApplicationHelper

	clear_respond_to 
  respond_to :js

  before_action :new_task, only: :create
  before_action :set_csrf_headers, only: :new
  after_action :set_csrf_headers, only: :create
  after_action :set_flash_message_now, only: [:create, :destroy]
  
  def destroy 
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
  end

end  