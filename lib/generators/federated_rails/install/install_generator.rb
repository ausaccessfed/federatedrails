require 'rails/generators/migration'

module FederatedRails
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      argument :model, :type => :string, :desc => "The model name to represent the applications subject (recommend: Subject)"
      class_option :createsubject, :optional => true, :type => :boolean, :default => true, :desc => "Create the subject model and migrations? False if object exists."
      include Rails::Generators::Migration
      source_root File.expand_path('../../templates', __FILE__)
      desc "add the migrations"

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.to_f
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializers
        template "warden.rb.erb", "config/initializers/warden.rb"
        template "federation.rb.erb", "config/initializers/federation.rb"
        template "provisioning_manager.rb.erb", "config/initializers/provisioning_manager.rb"
        template "security_manager.rb.erb", "config/initializers/security_manager.rb"
      end

      def copy_models
        if options[:createsubject]
          template "subject.rb.erb", "app/models/#{model.downcase}.rb"
          template "session_record.rb.erb", "app/models/session_record.rb"

          migration_template "create_subjects.rb.erb", "db/migrate/create_#{model.downcase}s.rb"
          migration_template "create_session_records.rb.erb", "db/migrate/create_session_records.rb"
        end
      end

      private

    end
  end
end
