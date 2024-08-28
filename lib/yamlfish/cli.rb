# frozen_string_literal: true

require_relative "cli/version"
require_relative "cli/push"
require_relative "cli/pull"
require "yaml"
require "rainbow"

module Yamlfish
  module Cli
    class Error < StandardError; end
    # Your code goes here...

    def self.configuration
      @configuration ||= Configuration.new
    end

    class Configuration
      attr_accessor :api_key, :project_token, :base_url, :locales_path

      DEFAULT_BASE_URL = "https://yamlfish.dev/api/v1"
      DEFAULT_LOCALES_PATH = "config/locales"

      def initialize
        configuration = begin
          YAML.load_file(File.expand_path(".yamlfish.yml"))
        rescue Errno::ENOENT
          {}
        end

        @api_key = configuration["api_key"]
        @project_token = configuration["project_token"]
        @base_url = configuration["base_url"] || DEFAULT_BASE_URL
        @locales_path = configuration["locales_path"] || DEFAULT_LOCALES_PATH
      end
    end
  end
end
