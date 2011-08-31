
# This allows us to extend how Subject is provisioned and updated
# to suit the explict needs of the host application

FederatedRails::ProvisioningManager.module_eval do
	
	# Customize Subject management within production deployment

	# def provision( subject )
	# end

	# def update ( subject )
	# end

	# Customize Subject management within development deployment
	
	# def provision_development ( subject )
	# end

	# def update_development ( subject )
	# end

end