class Project < ActiveRecord::Base
	default_scope { order('created_at') } 
	has_many :tasks, dependent: :destroy
	validates :name, presence: true,length: {minimum: 4}
end
