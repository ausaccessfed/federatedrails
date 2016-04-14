require "spec_helper"

describe FederatedRails::AuthController, type: :controller do

  describe 'login' do

    it 'specifies HTTP 200 response and renders the login view when when autologin is true' do
      Rails.application.config.federation.automatelogin = false
      get :login
      expect(response.code).to eq '200'
      expect(response).to render_template 'login'
      expect(assigns(:spsession_url)).to eq '/Shibboleth.sso/Login?target=http://test.host/auth/federation'
    end

    it 'specifies HTTP 302 and sets location to Shibboleth SSO endpoint when autologin is false' do
      Rails.application.config.federation.automatelogin = true
      get :login
      expect(response.code).to eq '302'
      expect(response.location).to eq "http://test.host/Shibboleth.sso/Login?target=http://test.host/auth/federation"
    end

  end

  describe 'logout' do

    it 'specifies HTTP 200 response and sets location to app root' do
      subject = FactoryGirl.build :subject
      warden = double(Warden)
      allow(warden).to receive(:logout) { subject = 'terminated' }
      allow(warden).to receive(:user) { subject }
      allow(warden).to receive(:subject) { subject }
      request.env['warden'] = warden

      expect(warden.subject).to eq subject
      get :logout
      expect(response.code).to eq '302'
      expect(response.location).to eq 'http://test.host/'
      expect(subject).to eq 'terminated'
    end

  end

  describe 'federation_login' do

    it 'renders the loginerror partial and sets 403 HTTP response when the federation is disabled' do
      Rails.application.config.federation.federationactive = false

      get :federation_login
      expect(response.code).to eq '403'
      expect(response).to render_template('_loginerror')
    end

    it 'specifies HTTP 200 response and sets location to app root on success' do
      Rails.application.config.federation.federationactive = true

      subject = FactoryGirl.build :subject
      warden = double(Warden)
      allow(warden).to receive(:authenticate!) { }
      allow(warden).to receive(:user) { subject }
      allow(warden).to receive(:subject) { subject }
      request.env['warden'] = warden

      get :federation_login
      expect(response.code).to eq '302'
      expect(response.location).to eq 'http://test.host/'
    end

    it 'specifies HTTP 200 response and sets location to stored uri on success' do
      Rails.application.config.federation.federationactive = true

      subject = FactoryGirl.build :subject
      warden = double(Warden)
      allow(warden).to receive(:authenticate!) { }
      allow(warden).to receive(:user) { subject }
      allow(warden).to receive(:subject) { subject }
      request.env['warden'] = warden

      session[:security_manager_return_to] = '/test/location'

      get :federation_login
      expect(response.code).to eq '302'
      expect(response.location).to eq 'http://test.host/test/location'
    end

  end

  describe 'development_login' do

    it 'renders to the login error partial and sets 403 HTTP response when development is disabled' do
      Rails.application.config.federation.developmentactive = false

      get :development_login
      expect(response.code).to eq '403'
      expect(response).to render_template('_loginerror')
    end

    it 'specifies HTTP 200 response and sets location to app root on success' do
      Rails.application.config.federation.developmentactive = true

      subject = FactoryGirl.build :subject
      warden = double(Warden)
      allow(warden).to receive(:authenticate!) { }
      allow(warden).to receive(:user) { subject }
      allow(warden).to receive(:subject) { subject }
      request.env['warden'] = warden

      get :development_login
      expect(response.code).to eq '302'
      expect(response.location).to eq 'http://test.host/'
    end

    it 'specifies HTTP 200 response and sets location to stored uri on success' do
      Rails.application.config.federation.developmentactive = true

      subject = FactoryGirl.build :subject
      warden = double(Warden)
      allow(warden).to receive(:authenticate!) { }
      allow(warden).to receive(:user) { subject }
      allow(warden).to receive(:subject) { subject }
      request.env['warden'] = warden

      session[:security_manager_return_to] = '/test/location'

      get :development_login
      expect(response.code).to eq '302'
      expect(response.location).to eq 'http://test.host/test/location'
    end

  end

end
