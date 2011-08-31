
require 'federated_rails/provisioning_manager'

class FederatedRails::FederationStrategy < Warden::Strategies::Base

  include FederatedRails::ProvisioningManager

  def authenticate!
    if Rails.application.config.federation.federationactive

      principal = retrieve_federated_value :principal
      unless principal
        logger.error 'Authentication Error - Federation did not supply persistent ID'
        return fail! 'Authentication Error - Federation did not supply persistent ID'
      end

      credential = retrieve_federated_value :credential
      unless credential
        logger.error 'Authentication Error - Federation did not supply session ID'
        return fail! 'Authentication Error - Federation did not supply session ID'
      end

      subject = host_subject.find_or_initialize_by_principal(principal)

      if subject.new_record?
        logger.info "Creating new subject for principal #{subject.principal}"

        # The default implementation simply stores the principal
        # Customize provision_subject within an application initializer to meet your specific needs
        provision subject
      else
        logger.info "Updating returning #{subject} from federated source"

        # If you have attributes specific to your application that may change on the IdP side
        # such as names, email addresses and entitlemenets these will need to be updated at session establishment.
        # Customize update_subject within an application initializer to meet your specific needs.
        update subject
      end

      # Store details about this session
      remote_host = request.env['HTTP_X_FORWARDED_FOR'] ||= request.remote_ip()
      user_agent = request.env['HTTP_USER_AGENT']
      sr = SessionRecord.new( :credential => credential, :remote_host => remote_host, :user_agent => user_agent )
      subject.session_records << sr
      
      unless subject.save
        logger.error "Unable to persist federated subject"
        logger.debug sr.inspect
        subject.errors.each do |error|
          logger.error error
        end
        return fail! 'Authentication Error - Unable to persist federated subject'
      end

      success! subject
    else
      return fail! 'Authentication Error - Federated source is not enabled'
    end
  end

end
