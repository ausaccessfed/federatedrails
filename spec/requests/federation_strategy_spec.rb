require "spec_helper"

# We need to have the request environment setup in order to test strategies

describe FederatedRails::FederationStrategy do

  subject { FederatedRails::FederationStrategy.new(request.env, :federation_login) }

  describe 'authenticate!' do

    it 'when federated source is disabled does not execute' do
      Rails.application.config.federation.federationactive = false

      # This is simply to setup a request/response environment for use within the strategy
      # Used for same purpose in all examples
      get "/login"
      
      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Federated source is not enabled'
    end

    it 'when no principal is provided via the federation authentication fails' do
      Rails.application.config.federation.federationactive = true
      Rails.application.config.federation.attributes = false
      warden = double Warden
      warden.stub(:fail) { |msg| puts msg }

      get "/login"

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Federation did not supply persistent ID'
    end

    it 'when no credential is provided via the federation authentication fails' do
      Rails.application.config.federation.federationactive = true
      Rails.application.config.federation.attributes = false
      warden = double Warden
      warden.stub(:fail) { |msg| puts msg }

      get "/login", nil, { 'HTTP_PERSISTENT_ID' => 'http://test.host/idp!http://test.host/sp!1234' }

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Federation did not supply session ID'
    end

    it 'when the subject fails to save ensure error' do
      Rails.application.config.federation.federationactive = true
      Rails.application.config.federation.subject = 'Subject'
      Rails.application.config.federation.attributes = false

      user = FactoryGirl.create :subject
      get "/login", nil, { 'HTTP_PERSISTENT_ID' => 'http://test.host/idp!http://test.host/sp!1234', 'HTTP_SHIB_SESSION_ID' => '12345678' }
      Subject.any_instance.stub(:save).and_return false

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Unable to persist federated subject'
    end

    it 'when the subject does not exist ensure it is provisioned has a session record created and returns success' do
      Rails.application.config.federation.federationactive = true
      Rails.application.config.federation.subject = 'Subject'
      Rails.application.config.federation.attributes = false

      get "/login", nil, {  'HTTP_PERSISTENT_ID' => 'http://test.host/idp!http://test.host/sp!12345', 
                            'HTTP_SHIB_SESSION_ID' => '12345678',
                            'HTTP_X_FORWARDED_FOR' => 'http://test.host',
                            'HTTP_USER_AGENT' => 'test browser' }

      provisioned = false
      subject.stub(:provision).and_return { provisioned = true }

      lambda { 
        lambda { subject.authenticate! }.should change(SessionRecord, :count).by 1 
      }.should change(Subject, :count).by 1
      subject.result.should eq :success   
      subject.user.should be_valid
      provisioned.should eq true
      session_record = subject.user.session_records[0]
      session_record.credential.should eq '12345678'
      session_record.remote_host.should eq 'http://test.host'
      session_record.user_agent.should eq 'test browser'
    end

    it 'when the subject exists ensure it is updated has a session record created and returns success' do
      Rails.application.config.federation.federationactive = true
      Rails.application.config.federation.subject = 'Subject'
      Rails.application.config.federation.attributes = false

      get "/login", nil, {  'HTTP_PERSISTENT_ID' => 'http://test.host/idp!http://test.host/sp!1234', 
                            'HTTP_SHIB_SESSION_ID' => '12345678',
                            'HTTP_X_FORWARDED_FOR' => 'http://test.host',
                            'HTTP_USER_AGENT' => 'test browser' }

      user = FactoryGirl.create :subject
      updated = false
      subject.stub(:update).and_return { updated = true }

      lambda { 
        lambda { subject.authenticate! }.should change(SessionRecord, :count).by 1 
      }.should change(Subject, :count).by 0
      subject.result.should eq :success   
      subject.user.should be_valid
      updated.should eq true
      session_record = subject.user.session_records[0]
      session_record.credential.should eq '12345678'
      session_record.remote_host.should eq 'http://test.host'
      session_record.user_agent.should eq 'test browser'    
    end

  end

end