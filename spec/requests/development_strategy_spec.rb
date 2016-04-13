require "spec_helper"

# We need to have the request environment setup in order to test strategies

describe FederatedRails::DevelopmentStrategy, type: :request do

  subject { FederatedRails::DevelopmentStrategy.new(request.env, :development_login) }

  describe 'authenticate!' do

    it 'when development source is disabled does not execute' do
      Rails.application.config.federation.developmentactive = false

      # This is simply to setup a request/response environment for use within the strategy
      # Used for same purpose in all examples
      get "/login"

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Development source is not enabled'
    end

    it 'when no principal is provided via form authentication fails' do
      Rails.application.config.federation.developmentactive = true
      warden = double Warden
      warden.stub(:fail) { |msg| puts msg }

      # This is simply to setup a request/response environment for use within the strategy
      # Used for same purpose in all examples
      get "/login"

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Development environment did not supply persistent ID'
    end

    it 'when no credential is provided via the federation authentication fails' do
      Rails.application.config.federation.developmentactive = true
      warden = double Warden
      warden.stub(:fail) { |msg| puts msg }

      get "/login", { :principal => 'http://test.host/idp!http://test.host/sp!1234' }

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Development environment did not supply session ID'
    end

    it 'when the subject fails to save ensure error' do
      Rails.application.config.federation.developmentactive = true
      Rails.application.config.federation.subject = 'Subject'

      user = FactoryGirl.create :subject
      get "/login", { :principal => 'http://test.host/idp!http://test.host/sp!1234', :credential => '12345678' }
      Subject.any_instance.stub(:save).and_return false

      subject.authenticate!
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Unable to persist development subject'
    end

    it 'when the subject does not exist ensure it is provisioned has a session record created and returns success' do
      Rails.application.config.federation.developmentactive = true
      Rails.application.config.federation.subject = 'Subject'
      Rails.application.config.federation.autoprovision = true

      get "/login",  {  :principal => 'http://test.host/idp!http://test.host/sp!12345',
                        :credential => '12345678' },
                     {  'HTTP_X_FORWARDED_FOR' => 'http://test.host',
                        'HTTP_USER_AGENT' => 'test browser' }

      provisioned = false
      allow(subject).to receive(:provision_development) { provisioned = true }

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

    it 'when the subject does not exist and autoprovision is disabled ensure failure' do
      Rails.application.config.federation.developmentactive = true
      Rails.application.config.federation.autoprovision = false
      Rails.application.config.federation.subject = 'Subject'
      Rails.application.config.federation.attributes = false

      get "/login",{  :principal => 'http://test.host/idp!http://test.host/sp!12345',
                      :credential => '12345678' },
                   {  'HTTP_X_FORWARDED_FOR' => 'http://test.host',
                      'HTTP_USER_AGENT' => 'test browser' }
      lambda { subject.authenticate! }.should_not change(Subject, :count)
      subject.result.should eq :failure
      subject.message.should eq 'Authentication Error - Automatic provisioning is disabled in configuration'
    end

    it 'when the subject exists ensure it is updated has a session record created and returns success' do
      Rails.application.config.federation.developmentactive = true
      Rails.application.config.federation.subject = 'Subject'

      get "/login",  {  :principal => 'http://test.host/idp!http://test.host/sp!1234',
                        :credential => '12345678' },
                     {  'HTTP_X_FORWARDED_FOR' => 'http://test.host',
                        'HTTP_USER_AGENT' => 'test browser' }

      user = FactoryGirl.create :subject
      updated = false
      allow(subject).to receive(:update_development) { updated = true }

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
