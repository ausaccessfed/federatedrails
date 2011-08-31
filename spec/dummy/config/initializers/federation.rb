Dummy::Application.instance_eval do
	config.federation = ActiveSupport::OrderedOptions.new
	federation = config.federation

	# Key integration configuration
	federation.automatelogin = false
	federation.federationactive = true
	federation.developmentactive = true
	federation.autoprovision = false
	federation.subject = 'Subject'

	# SP session init endpoint
	federation.ssoendpoint = '/Shibboleth.sso/Login'
	federation.attributes = false

	# Attribute mappings
	federation.mapping = ActiveSupport::OrderedOptions.new
	federation.mapping.principal = {:header => 'HTTP_PERSISTENT_ID', :env => 'persistent-id'}			# The unique and persistent ID used to identify this principal for current and subsequent sessions (eduPersonTargetedID)
	federation.mapping.credential = {:header => 'HTTP_SHIB_SESSION_ID', :env => 'Shib-Session-ID'}		# The internal session key assigned to the session associated with the request and hence the credential used
	federation.mapping.entityID = {:header => 'HTTP_SHIB_IDENTITY_PROVIDER', :env => 'Shib-Identity-Provider'}		# The entityID of the IdP that authenticated the user associated with the request.
	federation.mapping.applicationID = {:header => 'HTTP_SHIB_APPLICATION_ID', :env => 'Shib-Application-ID'}		# The applicationId property derived for the request.
	federation.mapping.idpAuthenticationInstant = {:header => 'HTTP_SHIB_AUTHENTICATION_INSTANT', :env => 'Shib-Authentication-Instant'}		# The ISO timestamp provided by the IdP indicating the time of authentication. 

	## See mappings in your attribute-map.xml file to enable more attributes - some common additional requirements
	# federation.mapping.displayName = {:header => 'HTTP_DISPLAYNAME', :env => 'displayName'}
	# federation.mapping.email = {:header => 'HTTP_MAIL', :env => 'mail'}
end