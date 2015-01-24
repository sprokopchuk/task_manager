require 'rails_helper'
require 'helpers/wait_for_ajax_helper'

feature 'Task management' do 
	scenario "adds a new task" do
					@project = FactoryGirl.create(:project)
     visit root_path
     save_and_open_page
		puts @project.name
	end
end