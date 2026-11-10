require 'json'

module Fastlane
  module Actions
    class UpdateVersionAction < Action
      UPDATE_TYPE = {
        major: 'major',
        minor: 'minor',
        patch: 'patch'
      }.freeze
      
      def self.run(params)
        update_type = params[:type]
        new_build = params[:build]
        
        project_path = File.join(__dir__, '..', '..', 'EZ Recipes.xcodeproj', 'project.xcproj')
        project_file = File.read(project_path)
        project_json = JSON.parse(project_file, allow_trailing_comma: true)
        
        app_target_index = project_json['targets'].index { |target| target['product-type'] == 'application' }
        app_target = project_json['targets'][app_target_index]
        old_version = app_target['build-settings']['MARKETING_VERSION']
        old_build = app_target['build-settings']['CURRENT_PROJECT_VERSION']
        if new_build == nil
          new_build = (old_build.to_i + 1).to_s
        end
        
        major, minor, patch = old_version.split(".")
        case update_type
        when UPDATE_TYPE[:major]
          # Make the lower versions 0 when the upper version is incremented
          new_version = (major.to_i + 1).to_s + ".0.0"
        when UPDATE_TYPE[:minor]
          new_version = "#{major}." + (minor.to_i + 1).to_s + ".0"
        when UPDATE_TYPE[:patch]
          new_version = "#{major}.#{minor}." + (patch.to_i + 1).to_s
        end
        
        if update_type != nil
          project_json['targets'][app_target_index]['build-settings']['MARKETING_VERSION'] = new_version
        end
        project_json['targets'][app_target_index]['build-settings']['CURRENT_PROJECT_VERSION'] = new_build
        
        File.open(project_path, 'w') do |file|
          # Will convert the file into regular JSON format, which Xcode supports
          file.write(JSON.pretty_generate(project_json))
        end
        
        if update_type != nil
          UI.success("Updated the version from #{old_version} to #{new_version}")
        end
        UI.success("Updated the build number from #{old_build} to #{new_build}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Updates the version and/or build number of the app within project.xcproj'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :type,
                                       description: 'The type of version update: major, minor, or patch',
                                       optional: true,
                                       verify_block: proc do |value|
                                         if value != nil && !UPDATE_TYPE.key?(value.to_sym)
                                           UI.user_error!("Invalid update type provided: #{value}. Must be one of the following: major, minor, patch")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :build,
                                       description: 'The new build number, increments the existing build number if not provided',
                                       optional: true)
        ]
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
