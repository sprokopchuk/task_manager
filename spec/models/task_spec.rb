require 'rails_helper'

describe Task, :type => :model do

	before do
		@task = Task.new(name: "buy a milk", project_id: 2, user_id: 1)
	end

	it "is valid with name" do
		expect(@task).to be_valid
	end

	it "is invalid with name less than 4 characters" do
		@task.name = "aaa"
		@task.valid?
		expect(@task.errors[:name]).to include("is too short (minimum is 4 characters)")
	end

	it "is invalid without name" do
		@task.name = " "
		@task.valid?
		expect(@task.errors[:name]).to include("can't be blank")
	end

	it "is valid when priority between 0..2" do
		@task.priority = 2
		@task.valid?
		expect(@task.errors[:priority]).not_to include("is not included in the list")
	end

	it "is invalid when priority out of range 0..2" do
		@task.priority = 4
		@task.valid?
		expect(@task.errors[:priority]).to include("is not included in the list")
	end 

	it "is invalid when project_id is nil" do
		@task.project_id = nil
		@task.valid?
		expect(@task.errors[:project_id]).to include("can't be blank")
	end

end
