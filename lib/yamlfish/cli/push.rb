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
        translations = Dir.glob("./config/locales/**/*.yml").each_with_object({}) do |filename, translations|
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
        puts response.status
      end
    end
  end
end