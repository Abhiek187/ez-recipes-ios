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
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message("Parameter API Token: #{params[:api_token]}")

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::UPDATE_VERSION_CUSTOM_VALUE] = "my_val"
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

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        'You can use this action to do cool things...'
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
#        [
#          FastlaneCore::ConfigItem.new(key: :api_token,
#                                       # The name of the environment variable
#                                       env_name: 'FL_UPDATE_VERSION_API_TOKEN',
#                                       # a short description of this parameter
#                                       description: 'API Token for UpdateVersionAction',
#                                       verify_block: proc do |value|
#                                         unless value && !value.empty?
#                                           UI.user_error!("No API token for UpdateVersionAction given, pass using `api_token: 'token'`")
#                                         end
#                                         # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
#                                       end),
#          FastlaneCore::ConfigItem.new(key: :development,
#                                       env_name: 'FL_UPDATE_VERSION_DEVELOPMENT',
#                                       description: 'Create a development certificate instead of a distribution one',
#                                       # true: verifies the input is a string, false: every kind of value
#                                       is_string: false,
#                                       # the default value if the user didn't provide one
#                                       default_value: false)
#        ]
        [
          FastlaneCore::ConfigItem.new(key: :type,
                                       env_name: 'FL_UPDATE_VERSION_TYPE',
                                       description: 'The type of version update: major, minor, or patch',
                                       optional: true,
                                       verify_block: proc do |value|
                                         if value != nil && !UPDATE_TYPE.key?(value.to_sym)
                                           UI.user_error!("Invalid update type provided: #{value}. Must be one of the following: major, minor, patch")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :build,
                                       env_name: 'FL_UPDATE_VERSION_BUILD',
                                       description: 'The new build number, increments the existing build number if not provided',
                                       optional: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
#        [
#          ['UPDATE_VERSION_CUSTOM_VALUE', 'A description of what this value contains']
#        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ['Abhiek187']
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
