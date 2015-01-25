require 'rails_helper'
require 'helpers/wait_for_ajax_helper'
require 'helpers/tasks_helper_spec.rb'
feature 'Task management', js: true do 
		
	background do 
		@project = FactoryGirl.create(:project)
	end

	feature "adds a new task" do
=begin
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

  	scenario "with a invalid deadline" do
			visit root_path
  		fill_in "task[name]" ,		with: "Buy a milk"
  		fill_in "task[deadline]", with: "a"*5
  		expect{click_button "Add Task"}.not_to change{Task.count}
  		expect(page).to have_content("Please enter a correct date.")
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
  			expect(page.find('div[title="Normal priority"]').text).to eq("1")
  			expect(page.has_css?('div[title="Deadline"]')).to be_falsey
  	end
=end
  	scenario "with valid name and deadline" do #Must be solve a problem with the validataion fomat date: %d/%m/%Y
			visit root_path
  		fill_in "task[name]", 		with: "Buy a dog"
  		fill_in "task[deadline]", with: "3/12/2015"
  		expect{
  			click_button "Add Task"
  			wait_for_ajax
  			}.to change{Task.count}.by(1)
  			expect(page).to have_content("Task is created!")
  			expect(page).to have_content("Buy a dog")
  			expect(page.find('div[title="Normal priority"]').text).to eq("1")
  			save_and_open_page
  			expect(page.find('div[title="Deadline"]').text).to eq("3/12/2015")			
  	end
=begin
  	scenario "when to hover task and show for actions: edit, delete and prioritise" do
  		@task = FactoryGirl.create(:task, :project_id => @project.id)
			visit root_path
			expect(page.find("div[data-task_id=\"#{@task.id}\"] div.action-button", visible: false).visible?).to be_falsey 
			page.find("div[data-task_id=\"#{@task.id}\"]").hover
			expect(page.find("div[data-task_id=\"#{@task.id}\"] div.action-button").visible?).to be_truthy 
  	end
=end
	end
=begin
	feature "edit the task" do

		background do
			@task = FactoryGirl.create(:task, :project_id => @project.id)
		end

		scenario "when form for editing show task must be hidden" do
			visit root_path
			get_edit_form_for_task(@task)
			expect(page.find("div[data-task_id=\"#{@task.id}\"]", visible: false).visible?).to be_falsey 
		end

		scenario "with a blank name" do
			visit root_path
			get_edit_form_for_task(@task)
			fill_in "task_name", with: ""
			click_button "Update Task"
			expect(page).to have_content("This field is required.")
		end

		scenario "with a too short name" do
			visit root_path
			get_edit_form_for_task(@task)
			fill_in "task_name", with: "a"*3
			click_button "Update Task"
			expect(page).to have_content("Please enter at least 4 characters")
		end

		scenario "with invalid date" do
			visit root_path
			get_edit_form_for_task(@task)
			fill_in "task_name", 		 with: "Buy some water"
			fill_in "task_deadline", with: "a"*5
			click_button "Update Task"
			expect(page).to have_content("Please enter a correct date")
		end

		scenario "with valid name and without deadline" do
			visit root_path
			get_edit_form_for_task(@task)
			fill_in "task_name", 		 with: "Buy some water"
			click_button "Update Task"
			wait_for_ajax
			expect(page).to have_content("Buy some water")
			expect(page).to have_content("Task is updated!")
		end

		scenario "with valid name and deadline" do #must be solve the problem with te date format %d/%m/%Y

		end
		
		scenario "when created two tasks" do
			@other_task = FactoryGirl.create(:task, :name => "The second task", :project_id => @project.id)
			visit root_path
			get_edit_form_for_task(@task)
			get_edit_form_for_task(@other_task)
			expect(page).not_to have_field("task[name]", :with => @task.name)
			expect(page).to have_field("task[name]", :with => @other_task.name)
		end

	end

	feature "delete the task" do

		background do
			@task = FactoryGirl.create(:task, :project_id => @project.id)
			visit root_path
		end

		scenario "with pop-up alert" do
			expect(page).to have_content(@task.name)
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
			@task = FactoryGirl.create(:task, :project_id => @project.id, :priority => 2)
		end

		scenario "up" do
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
			@task = FactoryGirl.create(:task, :project_id => @project.id)
		end

		scenario "when task isn't done" do
			@task.update_attributes(:done => true)
			visit root_path
			expect(page).to have_content(@task.name)
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
			div_task = page.find("div[data-task_id=\"#{@task.id}\"]")
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
=end
end