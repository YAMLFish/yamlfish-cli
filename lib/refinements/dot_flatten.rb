# frozen_string_literal: true

module Refinements
  module DotFlatten
    refine Hash do
      def dot_flatten
        each_with_object({}) do |(k, v), h|
          if v.is_a? Hash
            v.dot_flatten.map do |h_k, h_v|
              h["#{k}.#{h_k}"] = h_v
            end
          else
            h[k] = v
          end
        end
      end

      def dot_unflatten
        each_with_object({}) do |(k, v), h|
          parts = k.split(".")
          data = h
          parts[...-1].each do |part|
            data = (data[part] ||= {})
          end
          data[parts.last] = v
        end
      end
    end
  end
end
