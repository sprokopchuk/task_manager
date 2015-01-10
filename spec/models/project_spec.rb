require 'rails_helper'

describe Project, :type => :model do

	before do
		@project = Project.new(name: "For home")
	end

	it "is valid with name" do
		expect(@project).to be_valid
	end

	it "is invalid without name" do
		@project.name = " "
		@project.valid?
		expect(@project.errors[:name]).to include("can't be blank")
	end
	
	it "is invalid when name is less than 4 characters" do
		@project.name = "aaa"
		@project.valid?
		expect(@project.errors[:name]).to include("is too short (minimum is 4 characters)")
	end

	it "is valid when assosiated tasks destroyed with project" do
		@project.save
		@project.tasks.create!(name: "buy a milk")
		expect{@project.destroy}.to change{Task.count}.by(-1)	
	end
	
end
