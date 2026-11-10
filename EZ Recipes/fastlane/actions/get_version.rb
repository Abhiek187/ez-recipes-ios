require 'json'

module Fastlane
  module Actions
    class GetVersionAction < Action
      def self.run(params)
        # __dir__ points to where this file is located, not where the Fastlane action is run
        project_path = File.join(__dir__, '..', '..', 'EZ Recipes.xcodeproj', 'project.xcproj')
        project_file = File.read(project_path)
        # project.xcproj is JSON5, not regular JSON
        project_json = JSON.parse(project_file, allow_trailing_comma: true)
        
        # Only look at the main application target
        app_target = project_json['targets'].find { |target| target['product-type'] == 'application' }
        version = app_target['build-settings']['MARKETING_VERSION']
        build = app_target['build-settings']['CURRENT_PROJECT_VERSION']
        
        return version, build
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Gets the version and build number of the app within project.xcproj'
      end

      def self.return_value
        'Returns both the version and build as an array'
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ['Abhiek187']
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
