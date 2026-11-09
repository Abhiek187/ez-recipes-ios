require 'json'

module Fastlane
  module Actions
    module SharedValues
      VERSION = :VERSION
      BUILD = :BUILD
    end

    class GetVersionAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message("Parameter API Token: #{params[:api_token]}")

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::GET_VERSION_CUSTOM_VALUE] = "my_val"
        project_path = File.join(__dir__, '..', '..', 'EZ Recipes.xcodeproj', 'project.xcproj')
        project_file = File.read(project_path)
        # project.xcproj is JSON5, not regular JSON
        project_json = JSON.parse(project_file, allow_trailing_comma: true)
        
        app_target = project_json['targets'].find { |target| target['product-type'] == 'application' }
        version = app_target['build-settings']['MARKETING_VERSION']
        build = app_target['build-settings']['CURRENT_PROJECT_VERSION']
        
        Actions.lane_context[SharedValues::VERSION] = version
        Actions.lane_context[SharedValues::BUILD] = build
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Gets the version and build number of the app within project.xcproj'
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
#                                       env_name: 'FL_GET_VERSION_API_TOKEN',
#                                       # a short description of this parameter
#                                       description: 'API Token for GetVersionAction',
#                                       verify_block: proc do |value|
#                                         unless value && !value.empty?
#                                           UI.user_error!("No API token for GetVersionAction given, pass using `api_token: 'token'`")
#                                         end
#                                         # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
#                                       end),
#          FastlaneCore::ConfigItem.new(key: :development,
#                                       env_name: 'FL_GET_VERSION_DEVELOPMENT',
#                                       description: 'Create a development certificate instead of a distribution one',
#                                       # true: verifies the input is a string, false: every kind of value
#                                       is_string: false,
#                                       # the default value if the user didn't provide one
#                                       default_value: false)
#        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['VERSION', 'The version number of the app'],
          ['BUILD', 'The build number of the app']
        ]
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
