require 'rails'

module FederatedRails
	
  module ActsAsFederated
    module InstanceMethods
      protected  
		  def ensure_valid_subject
		    unless security_manager.authenticated? 
		      session[:security_manager_return_to] = request.fullpath if request.get?
		      redirect_to :login
		      false
		    end
		  end
		  
		  def security_manager
		    @security_manager ||= SecurityManager.new request.env['warden']
		  end
    end
  end

end