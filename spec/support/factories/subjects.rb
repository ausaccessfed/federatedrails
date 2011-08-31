require "factory_girl"

FactoryGirl.define do
  factory :subject do
    principal 'http://test.host/idp!http://test.host/sp!1234'
  end
end