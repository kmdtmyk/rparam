# frozen_string_literal: true

require 'rails/generators/active_record'

module Rparam
  module Generators

    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def install
        migration_template 'migration.rb', 'db/migrate/create_controller_parameters.rb', migration_version: migration_version
        template 'model.rb', 'app/models/controller_parameter.rb'
      end

      def self.next_migration_number(*args)
        ActiveRecord::Generators::Base.next_migration_number(*args)
      end

      private

        def migration_version
          major = ActiveRecord::VERSION::MAJOR
          if major >= 5
            "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
          end
        end

    end

  end
end
