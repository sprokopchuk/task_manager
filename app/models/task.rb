class Task < ActiveRecord::Base
	
	default_scope { order('created_at') } 
	attr_reader :priorities

	belongs_to :project

	validates :name, presence: true, length: { minimum: 4 }
	validates :priority, inclusion: { :in => 1..3 }
	validates :project_id, presence: true
	validates :deadline, timeliness: {:type => :date}, :allow_blank => true
	validates :user_id, presence: true
	
	def priorities
		[nil, "Normal", "High", "Maximum"]
	end

end
