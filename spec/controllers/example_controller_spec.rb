require "spec_helper"

describe ExampleController, type: :controller  do

  describe 'index' do

    it 'specifies HTTP 302 response and sets location AuthController login when unauthenticated' do
      warden = double(Warden)
      allow(warden).to receive(:authenticated?) { false }
      request.env['warden'] = warden

      get :index
      expect(response.code).to eq '302'
      expect(subject).to redirect_to :controller => 'federated_rails/auth', :action => 'login'
    end

    it 'specifies HTTP 200 and renders the index view when authenticated' do
      subject = FactoryGirl.build :subject
      warden = double(Warden)
      allow(warden).to receive(:authenticated?) { true }
      allow(warden).to receive(:user) { subject }
      request.env['warden'] = warden

      get :index
      expect(response.code).to eq '200'
      expect(response).to render_template('index')
    end

  end

end
