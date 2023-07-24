# frozen_string_literal: true

require_relative "cli/version"
require_relative "cli/push"
require_relative "cli/pull"
require "yaml"

module I28s
  module Cli
    class Error < StandardError; end
    # Your code goes here...

    def self.configuration
      @configuration ||= Configuration.new
    end

    class Configuration
      attr_accessor :api_key, :project_token, :base_url

      DEFAULT_BASE_URL = "https://i28s.dev/api/v1"

      def initialize
        configuration = begin
          YAML.load_file(File.expand_path(".i28s.yml"))
        rescue Errno::ENOENT
          {}
        end

        @api_key = configuration["api_key"]
        @project_token = configuration["project_token"]
        @base_url = configuration["base_url"] || DEFAULT_BASE_URL
      end
    end
  end
end
