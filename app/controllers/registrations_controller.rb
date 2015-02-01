class RegistrationsController < Devise::RegistrationsController  
	
	include ApplicationHelper

	clear_respond_to
  respond_to :js

  before_action :set_csrf_headers, only: :new
  after_action :set_flash_message_now, only: [:create, :update, :destroy]

end 