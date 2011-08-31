require 'spec_helper'

describe "Dummy" do
  
  it "is a valid rails app" do
    ::Rails.application.should be_a(Dummy::Application)
  end

end
