# frozen_string_literal: true

require "faraday"
require "json"
require_relative "../../refinements/dot_flatten"
require_relative "yaml_dumper"

module Yamlfish
  module Cli
    class Pull
      using Refinements::DotFlatten

      def initialize(locale_identifier, inplace: false, force_update: false, branch: "main")
        @locale_identifier = locale_identifier
        @inplace = inplace
        @force_update = force_update
        @branch = branch
      end

      def call
        response = Faraday.get(
          "#{Yamlfish::Cli.configuration.base_url}/projects/#{Yamlfish::Cli.configuration.project_token}/#{@branch}/locales/#{@locale_identifier}/export",
          {},
          {
            "Authorization": "Bearer #{Yamlfish::Cli.configuration.api_key}"
          }
        )

        if response.status != 200
          puts Rainbow("Failed to pull, unexpected HTTP status #{response.status}").red.bright
          exit 1
        end

        translations = JSON.parse(response.body)

        if @inplace
          replace_inplace(translations)
          puts "Fetched translations in-place for locale #{Rainbow(@locale_identifier).magenta.bright}"
        else
          dump_translations(translations)
          puts "Downloaded new translations for locale #{Rainbow(@locale_identifier).magenta.bright}"
        end
      end

      private

      def replace_inplace(translations)
        Dir.glob("./#{Yamlfish::Cli.configuration.locales_path}/**/*.yml").each do |filename|
          file = YAML.load_file(filename).dot_flatten
          update = false

          file.each do |key, value|
            if translations.has_key?(key) && translations[key] != value
              update = true
              file[key] = translations[key]
            end
          end

          File.write(filename, Yamlfish::Cli::YamlDumper.dump(file.dot_unflatten)) if update || @force_update
        end
      end

      def dump_translations(translations)
        File.write("./#{Yamlfish::Cli.configuration.locales_path}/#{@locale_identifier}.yml", Yamlfish::Cli::YamlDumper.dump(translations.dot_unflatten))
      end
    end
  end
end
