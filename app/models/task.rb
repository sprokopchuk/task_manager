class Task < ActiveRecord::Base
	
	attr_reader :priorities

	belongs_to :projects
	validates :name, presence: true, length: { minimum: 4 }
	validates :priority, inclusion: { :in => 0..2 }
	validates :project_id, presence: true

	def priorities
		["Normal", "High", "Maximum"]
	end

## Controllers methods
	#def up_priority				

	#end

	#def down_priority
	#end

end
