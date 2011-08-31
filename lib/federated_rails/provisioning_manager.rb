module FederatedRails
	module ProvisioningManager

		def provision (subject)
			logger.debug "Executed default NOOP provisioner against #{subject}"
		end

		def update (subject)
			logger.debug "Executed default NOOP updater against #{subject}"
		end

		def provision_development (subject)
			logger.debug "Executed default NOOP development provisioning against #{subject}"
		end

		def update_development (subject)
			logger.debug "Executed default NOOP development updater against #{subject}"
		end

		def retrieve_federated_value(attr)
	  	if Rails.application.config.federation.attributes
	  		env[ Rails.application.config.federation.mapping[attr][:env] ]
	  	else
	  		env[ Rails.application.config.federation.mapping[attr][:header] ]
	  	end
		end

		def host_subject
			Object::const_get(Rails.application.config.federation.subject)
		end

	end
end