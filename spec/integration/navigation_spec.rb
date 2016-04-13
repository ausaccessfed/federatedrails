require 'spec_helper'

describe "Dummy" do

  it "is a valid rails app" do
    expect(::Rails.application).to be_a(Dummy::Application)
  end

end
