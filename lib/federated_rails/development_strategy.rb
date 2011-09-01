
require 'federated_rails/provisioning_manager'

module FederatedRails
  class DevelopmentStrategy < Warden::Strategies::Base

    include ProvisioningManager

    def authenticate!

      if Rails.application.config.federation.developmentactive
        principal = params[:principal]
        unless principal
          return fail! 'Authentication Error - Development environment did not supply persistent ID'
        end

        credential = params[:credential]
        unless credential
          return fail! 'Authentication Error - Development environment did not supply session ID'
        end

        subject = host_subject.find_or_initialize_by_principal(params[:principal])
        
        if subject.new_record?
          unless Rails.application.config.federation.autoprovision
            logger.error 'Authentication Error - Automatic provisioning is disabled in configuration'
            return fail! 'Authentication Error - Automatic provisioning is disabled in configuration'
          end

          logger.info "Creating new subject for principal #{subject.principal}"

          # The default implementation simply stores the principal
          # Customize provision_subject_development within an application initializer to meet your specific needs
          provision_development subject
        else
          logger.info "Updating returning #{subject} from development source"

          # If you have attributes specific to your application that may change on the IdP side
          # such as names, email addresses and entitlemenets these will need to be updated at session establishment.
          # Customize update_subject_development within an application initializer to meet your specific needs.
          update_development subject
        end

        # Store details about this session
        remote_host = request.env['HTTP_X_FORWARDED_FOR'] ||= request.remote_ip()
        user_agent = request.env['HTTP_USER_AGENT']
        sr = SessionRecord.new( :credential => credential, :remote_host => remote_host, :user_agent => user_agent )
        subject.session_records << sr
        
        unless subject.save
          logger.error "Unable to persist development subject"
          subject.errors.each do |error|
            logger.error error
          end
          return fail! 'Authentication Error - Unable to persist development subject'
        end
        
        success!(subject)
      else
        return fail! 'Authentication Error - Development source is not enabled'
      end
    end
  end
end