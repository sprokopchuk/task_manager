require 'rails_helper'
require 'helpers/wait_for_ajax_helper'
require 'helpers/projects_helper_spec.rb'
feature 'Project management', js: true do 
	
	feature "adds a new project" do

		before do 
			visit root_path
			click_button 'Add TODO List'
			wait_for_ajax
		end

		scenario "where field for project name is present" do
			expect(page).to have_field("project[name]")
		end

		scenario "with invalid blank name" do
			expect{click_button "Add project"}.not_to change{Project.count}	
			expect(page).to have_content("This field is required.")
		end

		scenario "with too short name" do
			fill_in "project[name]", with: "a"*3
			expect{click_button "Add project"}.not_to change{Project.count}	
			expect(page).to have_content("Please enter at least 4 characters.")
		end		

		scenario 'with valid information' do
			fill_in "project[name]", with: "This is my first project"
			expect{			
				click_button "Add project"
				wait_for_ajax
				}.to change{Project.count}.by(1)
			expect(page).to have_content("Project created!")
			expect(page).to have_content("This is my first project")
		end

	end

	feature "edit the project" do
		
		background do
			@project = FactoryGirl.create(:project)
		end

		scenario "with blank name" do 
			visit root_path
			get_edit_form_for_project(@project)
			fill_in "project[name]", with: ""
			click_button "Update project"
			expect(page).to have_content("This field is required.")	
		end
		
		scenario "with too short name" do 
			visit root_path
			get_edit_form_for_project(@project)
			fill_in "project[name]", with: "a"*3
			click_button "Update project"
			expect(page).to have_content("Please enter at least 4 characters.")	
		end
		
		scenario 'with valid information' do 
			visit root_path
			get_edit_form_for_project(@project)
			fill_in "project[name]", with: "Project with new name"
			click_button "Update project"
			wait_for_ajax
			expect(page).to have_content("Project updated!")
			expect(page).to have_content("Project with new name")	
		end

		scenario "when created two projects" do
			@other_project = FactoryGirl.create(:project, :name => "This is my second project")
			visit root_path
			get_edit_form_for_project(@project)
			get_edit_form_for_project(@other_project)
			expect(page).not_to have_field("project[name]", :with => @project.name)
			expect(page).to have_field("project[name]", :with => @other_project.name)
		end

		scenario "when form for editing show project must be hidden" do 
		end

	end

	feature "delete the project" do
		
		background do 
			@project = FactoryGirl.create(:project)
			visit root_path
		end	

		scenario "with pop-up alert" do 
			page.find("a[href=\"/projects/#{@project.id}\"]").click
			a = page.driver.browser.switch_to.alert
			expect(a.text).to eq("Project and dependent tasks will be destroyed. Are you sure?")
			expect{
				a.accept
				wait_for_ajax
				}.to change{Project.count}.by(-1)
			expect(page).to have_content("Project and dependent tasks are destroyed!")
		end

	end

end