module FederatedRails
	  module ActionControllerExtension
    module ClassMethods
      def acts_as_federated
        # At this point, 'self' is the ApplicationController
        self.send :include, ::FederatedRails::ActsAsFederated::InstanceMethods
        self.before_filter :ensure_valid_subject
        self.helper_method :security_manager
      end
    end
  end
end