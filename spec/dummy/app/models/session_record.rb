class SessionRecord < ActiveRecord::Base
  belongs_to :subject

  validates_presence_of :credential, :remote_host, :user_agent
end
