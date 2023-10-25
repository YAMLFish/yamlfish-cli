# frozen_string_literal: true

module I28s
  module Cli
    class YamlDumper
      # We want to dump strings that contain newlines as literal scalars for readability
      # Inspired by https://github.com/ruby/psych/issues/322#issuecomment-328408276
      def self.dump(object)
        str = YAML.dump(object)

        ast = Psych.parse_stream(str)
        ast.grep(Psych::Nodes::Scalar).each do |node|
          node.style  = Psych::Nodes::Scalar::LITERAL if node.value.include?("\n")
        end

        ast.yaml(nil, {line_width: -1})
      end
    end
  end
end
