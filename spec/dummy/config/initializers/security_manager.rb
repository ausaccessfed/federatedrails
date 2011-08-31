
# This allows us to extend how security is managed
# to suit the explict needs of the host application

FederatedRails::SecurityManager.class_eval do
  
  def subject
    warden.user
  end

end