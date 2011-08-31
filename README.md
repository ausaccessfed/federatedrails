# FederatedRails - 0.1

Allows Ruby on Rails applications to easily integrate to federated authentication sources particuarly those served by Shibboleth service providers.

Utilizes Warden as an underlying mechanism so can be adjusted for non RoR rack applications with relative ease.

Concepts
--------
* Subject - Security specific view of an entity capable of being authenticated to an application. It can be a human being, a third-party process, a server etc. Also referred to as ‘user’.
* Principal - A subjects uniquely identifying attribute. This is generally mapped to the federation attribute eduPersonTargetedID. For non federated applications this is commonly referred to as a ‘username’
* Credentials - Data used to verify identity at session establishment. For integrators this is the associated SAML assertion and is represented by a unique internal sessionID. For non federated applications this is usually a ‘password’
* Attributes - A subjects identifying attributes. Names, email, entitlements etc.For non federated applications these need to manually entered. For federated applications they are in many cases automatically supplied.

Documentation
-------------
You'll find all the documentation for FederatedRails at http://wiki.aaf.edu.au/spintegrators/federatedrails

Installation
------------
This isn't currently published to a gem repository given early release status.

Clone the repository to your local disk and in your Gemfile add:

gem 'federated_rails', '0.1.0', :path => "yourpath/federated_rails"

Alternatively use the bundler git syntax. 

Once this is done execute the supplied generator

rails g federated_rails:install Subject

Subject should be the name of your subject class you can change this to say User if this better suits your application.

Then simply continue with Bundler as normal.

Contributing
------------
All contributions welcome. Simply fork and send a pull request when you have something new or log an issue.

Credits
-------
FederatedRails was written by Bradley Beddoes on behalf of the Australian Access Federation.