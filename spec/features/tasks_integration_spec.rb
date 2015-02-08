require 'rails_helper'
require 'helpers/wait_for_ajax_helper'
require 'helpers/tasks_helper.rb'
include Warden::Test::Helpers

feature 'Task management', js: true do 
		
	background do 
		@user = FactoryGirl.create(:user)
		@project = FactoryGirl.create(:project, :user_id => @user.id)
		login_as @user, :scope => :user
	end

	feature "adds a new task" do

  	scenario "where fields for task name and deadline are present" do
  		visit root_path
  		expect(page).to have_field("task[name]")
  		expect(page).to have_field("task[deadline]")
  	end

  	scenario "with a blank name" do
			visit root_path  		
  		expect{click_button "Add Task"}.not_to change{Task.count}
  		expect(page).to have_content("This field is required.")
  	end

  	scenario "with a too short name" do
			visit root_path
  		fill_in "task[name]", with: "a"*3
  		expect{click_button "Add Task"}.not_to change{Task.count}
  		expect(page).to have_content("Please enter at least 4 characters.")
  	end

  	scenario "with valid name and without deadline" do
			visit root_path
  		fill_in "task[name]", with: "Buy a milk"
  		expect{
  			click_button "Add Task"
  			wait_for_ajax
  			}.to change{Task.count}.by(1)
  			expect(page).to have_content("Task is created!")
  			expect(page).to have_content("Buy a milk")
  			expect(find('div[title="Normal priority"]').text).to eq("1")
  			expect(page.has_css?('div[title="Deadline"]')).to be_falsey
  	end

  	scenario "with valid name and deadline" do
			visit root_path
  		fill_in "task[name]", 		with: "Buy a dog"
  		find("input[name*=deadline]").click
  		expect{
  			click_button "Add Task"
  			wait_for_ajax
  			}.to change{Task.count}.by(1)
  			expect(page).to have_content("Task is created!")
  			expect(page).to have_content("Buy a dog")
  			expect(find('div[title="Normal priority"]').text).to eq("1")
  			expect(find('span[title="Deadline"]').text).to eq(Date.today.strftime("%d-%m-%Y"))			
  	end

  	scenario "when to hover task and show for actions: edit, delete and prioritise" do
  		@task = FactoryGirl.create(:task, :project_id => @project.id, :user_id => @user.id)
			visit root_path
			expect(find("div[data-task_id=\"#{@task.id}\"] div.action-button", visible: false).visible?).to be_falsey 
			find("div[data-task_id=\"#{@task.id}\"]").hover
			expect(find("div[data-task_id=\"#{@task.id}\"] div.action-button").visible?).to be_truthy 
  	end

	end

	feature "edit the task" do

		background do
			@task = FactoryGirl.create(:task, :project_id => @project.id, :user_id => @user.id)
   	end

		scenario "when form for editing show task must be hidden" do
			visit root_path
			get_edit_form_for_task(@task)
			expect(find("div[data-task_id=\"#{@task.id}\"]", visible: false).visible?).to be_falsey 
		end

		scenario "with a blank name" do
			visit root_path
			get_edit_form_for_task(@task)
			within "#edit_task_#{@task.id}" do
				fill_in "task[name]", with: ""
			end
			click_button "Update Task"
			expect(page).to have_content("This field is required.")
		end

		scenario "with a too short name" do
			visit root_path
			get_edit_form_for_task(@task)
			within "#edit_task_#{@task.id}" do			
				fill_in "task[name]", with: "a"*3
			end
			click_button "Update Task"
			expect(page).to have_content("Please enter at least 4 characters")
		end

		scenario "with valid name and without deadline" do
			visit root_path
			get_edit_form_for_task(@task)
			within "#edit_task_#{@task.id}" do
				fill_in "task[name]", 		 with: "Buy some water"
			end
			click_button "Update Task"
			wait_for_ajax
			expect(page).to have_content("Buy some water")
			expect(page).to have_content("Task is updated!")
		end

		scenario "with valid name and deadline" do 
			visit root_path
			get_edit_form_for_task(@task)
 			within "#edit_task_#{@task.id}" do
  			fill_in "task[name]", 		with: "Buy Birthday Flowers for Mom"
  			find("input[name*=deadline]").click
  		end
  		click_button "Update Task"
  		wait_for_ajax
			expect(page).to have_content("Task is updated!")
  		expect(page).to have_content("Buy Birthday Flowers for Mom")
  		expect(find('span[title="Deadline"]').text).to eq(Date.today.strftime("%d-%m-%Y"))			
		end
	
		scenario "when created two tasks" do
			@other_task = FactoryGirl.create(:task, :name => "The second task", :project_id => @project.id, :user_id => @user.id)
			visit root_path
			get_edit_form_for_task(@task)
			get_edit_form_for_task(@other_task)
			expect(page).not_to have_field("task[name]", :with => @task.name)
			expect(page).to have_field("task[name]", :with => @other_task.name)
		end

	end

	feature "delete the task" do

		background do
			@task = FactoryGirl.create(:task, :project_id => @project.id, :user_id => @user.id)
			visit root_path
		end

		scenario "with pop-up alert" do
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			div_task.hover
			div_task.find("a[href=\"/tasks/#{@task.id}\"]").click	
			a = page.driver.browser.switch_to.alert
			expect(a.text).to eq("You wanna delete task?")
			expect{
				a.accept
				wait_for_ajax
				}.to change{Task.count}.by(-1)
			expect(page).to have_content("Successefully destroyed task!")
		end

	end

	feature "prioritise the task" do

		background do
			@task = FactoryGirl.create(:task, :project_id => @project.id, :priority => 2, :user_id => @user.id)
		end

		scenario "up" do
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			div_task.hover
			expect{
				div_task.find("button[value=\"up\"]").click
				wait_for_ajax
				@task.reload
				}.to change{@task.priority}.by(1)
			expect(div_task.find("div[title=\"#{@task.priorities[@task.priority]} priority\"]").text).to eq("#{@task.priority}")
		end

		scenario "down" do
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			div_task.hover
			expect{
				div_task.find("button[value=\"down\"]").click
				wait_for_ajax		
				@task.reload
				}.to change{@task.priority}.by(-1)
			expect(div_task.find("div[title=\"#{@task.priorities[@task.priority]} priority\"]").text).to eq("#{@task.priority}")			
		end

		scenario "when priority of the task equl 1" do
			@task.update_attributes(:priority => 1)
			@task.reload
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			div_task.hover
			expect{
				div_task.find("button[value=\"down\"]").click
				wait_for_ajax		
				@task.reload
				}.not_to change{@task.priority}
		end	
		
		scenario "when priority of the task equl 3" do
			@task.update_attributes(:priority => 3)
			@task.reload
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			div_task.hover
			expect{
				div_task.find("button[value=\"up\"]").click
				wait_for_ajax		
				@task.reload
				}.not_to change{@task.priority}			
		end

	end

	feature "mark the task as done" do
		
		background do
			@task = FactoryGirl.create(:task, :project_id => @project.id, :user_id => @user.id)
		end

		scenario "when task isn't done" do
			@task.update_attributes(:done => true)
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			expect(div_task.find('input[type="checkbox"]').checked?).to be_truthy
			expect{
				div_task.find('input[type="checkbox"]').click
				wait_for_ajax
				@task.reload
			}.to change{@task.done}.from(true).to(false)
			visit root_path
			expect(div_task.find('input[type="checkbox"]').checked?).to be_falsey			
		end		

		scenario "when task is done" do
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = find("div[data-task_id=\"#{@task.id}\"]")
			expect(div_task.find('input[type="checkbox"]').checked?).to be_falsey
			expect{
				div_task.find('input[type="checkbox"]').click
				wait_for_ajax
				@task.reload
			}.to change{@task.done}.from(false).to(true)
			visit root_path
			expect(div_task.find('input[type="checkbox"]').checked?).to be_truthy
		end				

	end

end