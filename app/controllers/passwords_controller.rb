class PasswordsController < Devise::PasswordsController
	clear_respond_to 
  respond_to :js, :json
end