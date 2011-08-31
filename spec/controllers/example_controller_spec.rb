require "spec_helper"

describe ExampleController do

	describe 'index' do
	
		it 'specifies HTTP 302 response and sets location AuthController login when unauthenticated' do

			warden = double(Warden)
  		warden.stub(:authenticated?) { false }
  		request.env['warden'] = warden
		
			get :index
			response.code.should eq '302'
			subject.should redirect_to :controller => 'federated_rails/auth', :action => 'login'

		end

		it 'specifies HTTP 200 and renders the index view when authenticated' do

			subject = FactoryGirl.build :subject
			warden = double(Warden)
  		warden.stub(:authenticated?) { true }
  		warden.stub(:user) { subject }
  		request.env['warden'] = warden
		
			get :index
			response.code.should eq '200'
			response.should render_template('index')

		end

	end

end