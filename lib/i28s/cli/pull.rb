# frozen_string_literal: true

require "faraday"
require "json"
require_relative "../../refinements/dot_flatten"
require_relative "yaml_dumper"

module I28s
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
          "#{I28s::Cli.configuration.base_url}/projects/#{I28s::Cli.configuration.project_token}/#{@branch}/locales/#{@locale_identifier}/export",
          {},
          {
            "Authorization": "Bearer #{I28s::Cli.configuration.api_key}"
          }
        )
        translations = JSON.parse(response.body)

        if @inplace
          replace_inplace(translations)
        else
          dump_translations(translations)
        end
      end

      private

      def replace_inplace(translations)
        Dir.glob("./config/locales/**/*.yml").each do |filename|
          file = YAML.load_file(filename).dot_flatten
          update = false

          file.each do |key, value|
            if translations.has_key?(key) && translations[key] != value
              update = true
              file[key] = translations[key]
            end
          end

          File.write(filename, I28s::Cli::YamlDumper.dump(file.dot_unflatten)) if update || @force_update
        end
      end

      def dump_translations(translations)
        File.write("./config/locales/#{@locale_identifier}.yml", I28s::Cli::YamlDumper.dump(translations.dot_unflatten))
      end
    end
  end
end
