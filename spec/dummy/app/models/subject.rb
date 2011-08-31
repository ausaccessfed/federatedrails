class Subject < ActiveRecord::Base
	has_many :session_records

	validates_presence_of :principal
	validates_uniqueness_of :principal

	validates_associated :session_records

	def to_s
		"subject [#{self.id}, #{self.principal}]"
	end
end
