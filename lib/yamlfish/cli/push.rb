# frozen_string_literal: true

require "active_support/core_ext/hash/deep_merge"
require "faraday"

module Yamlfish
  module Cli
    class Push
      def initialize(locale_identifier, branch: "main")
        @locale_identifier = locale_identifier
        @branch = branch
      end

      def call
        translations = Dir.glob("./#{Yamlfish::Cli.configuration.locales_path}/**/*.yml").each_with_object({}) do |filename, translations|
          translations.deep_merge!(YAML.load_file(filename))
        end

        translations = translations[@locale_identifier]

        raise "No translations" unless translations&.any?

        response = Faraday.post(
          "#{Yamlfish::Cli.configuration.base_url}/projects/#{Yamlfish::Cli.configuration.project_token}/#{@branch}/locales/#{@locale_identifier}/import",
          { data: JSON.dump(translations) },
          {
            "Authorization": "Bearer #{Yamlfish::Cli.configuration.api_key}"
          }
        )
        if response.status == 201
          puts "Successfully pushed translations for locale #{Rainbow(@locale_identifier).magenta.bright} on branch #{Rainbow(@branch).magenta.bright}"
        else
          puts Rainbow("Failed to push, unexpected HTTP status #{response.status}").red.bright
        end
      end
    end
  end
end
