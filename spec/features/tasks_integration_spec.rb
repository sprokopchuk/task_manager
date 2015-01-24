require 'rails_helper'
require 'helpers/wait_for_ajax_helper'

feature 'Task management', js: true do 
	
	feature "adds a new task" do
		
		background do 
			@project = FactoryGirl.create(:project)
  	end

  	scenario "with a blank name" do
  	end

  	scenario "with a too short name" do
  	end

  	scenario "with a invalid deadline" do
  	end

  	scenario "with valid name" do
  	end

  	scenario "with valid name and deadline" do
  	end

	end

	feature "edit the task" do

		scenario "with a blank name" do
		end

		scenario "with a too short name" do
		end

		scenario "with invalid date" do
		end

		scenario "with valid name and deadline" do
		end

		scenario "when created two tasks" do
		end

	end

	feature "delete the task" do
	end

	feature "prioritise the task" do
	end

	feature "mark the task as done" do
	end

end