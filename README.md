# FederatedRails - 0.1

Allows Ruby on Rails applications to easily integrate to federated authentication sources particuarly those served by Shibboleth service providers.

Utilizes Warden as an underlying mechanism so can be adjusted for non RoR rack applications with relative ease.

Concepts
--------
* Subject - Security specific view of an entity capable of being authenticated to an application. It can be a human being, a third-party process, a server etc. Also referred to as ‘user’.
* Principal - A subjects uniquely identifying attribute. This is generally mapped to the federation attribute eduPersonTargetedID. For non federated applications this is commonly referred to as a ‘username’
* Credentials - Data used to verify identity at session establishment. For integrators this is the associated SAML assertion and is represented by a unique internal sessionID. For non federated applications this is usually a ‘password’
* Attributes - A subjects identifying attributes. Names, email, entitlements etc.For non federated applications these need to manually entered. For federated applications they are in many cases automatically supplied.

Demonstration
-------------
To get started a *very* basic sample app is provided at spec/dummy.
 
    bundler exec unicorn 

to try it out.

Installation
------------
Prerequisite: Your Shibboleth SP is setup and working correctly (this doesn't apply if you simply wish to enable development mode on your local development environment). We recommend the use of LazySessions with this implementation to give your app more control.

This version isn't published to a gem repository given early release status.

Clone the repository to your local disk and in your Gemfile add:

		gem 'federated_rails', '0.1.0', :path => "yourpath/federated_rails"

Alternatively use the bundler git syntax. 

Once this is done execute the supplied generator

		rails g federated_rails:install Subject

Subject should be the name of your subject class you can change this to say User if this better suits your application.

You'll then need to add

    acts_as_federated
    
to your application_controller.rb. This will authenticate all controller requests except supplied by the engine. To disable use:

    skip_before_filter :ensure_valid_subject 

Configuration
-------------
All configuration is managed in the supplied files:

    config/initializers/federation.rb and config/initializers/warden.rb

* automatelogin - When the user needs to login they will be forwarded directly to the Shibboleth configured endpoint and not shown the login view.
* federationactive - The application is being protected by a shibboleth instance
* developmentactive - The application is in development mode and accounts may be specified on the login page
* autoprovision - New users to the system will be automatically created
* subject - The name of your subject class, generally Subject but maybe User is you changed during installation.
* ssoendpoint - The endpoint within you Shibboleth SP configuration that will initiate a session
* attributes - To use apache environment variables or HTTP headers to retrieve attributes. Generally in RoR this should be false.
* mapping.XYZ - The set of attributes you expect to be delivered to your SP by remote IdP and available in your app

Advanced Integration
--------------------
The following files allow you to extend the integration between the federation and your local application

    config/initializers/security_manager.rb
    config/initializers/provisioning_manager.rb

security_manager is available to your controllers and views to provide details about the authenticated subject. In some cases it may make sense to further extend this.

provisioning_manager allows you to modify what happens when a Subject is created or how it is updated when they subsequently visit your application.

Contributing
------------
All contributions welcome. Simply fork and send a pull request when you have something new or log an issue.

For code changes please ensure you supply working tests and documentation.

Requests for additional information to go along with this documentation are also welcomed.

Credits
-------
FederatedRails was written by Bradley Beddoes on behalf of the Australian Access Federation.

