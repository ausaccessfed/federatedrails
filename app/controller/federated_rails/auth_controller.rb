
class FederatedRails::AuthController < ApplicationController

  skip_before_filter :ensure_valid_subject

  def login
    # Integrates with Shibboleth NativeSPSessionCreationParameters as per https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPSessionCreationParameters
    login_url = "#{Rails.application.config.federation.ssoendpoint}?target=#{url_for(:controller => 'auth', :action => 'federation_login')}"
    if Rails.application.config.federation.automatelogin
      redirect_to login_url
      return
    end

    @spsession_url = login_url
  end

  def logout
    uri = url_for root_path
    logger.info "Logging out principal #{security_manager.subject.principal} and directing to #{uri.inspect}" if security_manager.subject
    warden.logout
    redirect_to uri
  end

  def unauthenticated
  end

  def federation_login
    if Rails.application.config.federation.federationactive
      warden.authenticate!(:federation_login)
      
      uri = session[:security_manager_return_to] ||= url_for(root_path)
      logger.info "Redirecting principal #{security_manager.subject.principal} to #{uri.inspect}"
      redirect_to uri
    else
      logger.error "Attempt utilize federation login when federation disabled"
      render :partial => "loginerror", :nothing => true, :status => :forbidden
      return
    end
  end

  def development_login
    if Rails.application.config.federation.developmentactive
      warden.authenticate!(:development_login)
      
      uri = session[:security_manager_return_to] ||= url_for(root_path)
      logger.info "Redirecting principal #{security_manager.subject.principal} to #{uri.inspect}"
      redirect_to uri
    else
      logger.error "Attempt utilize development login when development is disabled"
      render :partial => "loginerror", :nothing => true, :status => 403
      return
    end
  end 

end
