#!/usr/bin/env ruby
# frozen_string_literal: true

require "thor"
require_relative "../lib/i28s/cli"

class I28sExe < Thor
  desc "push", "Pushes translations to i28s"
  option :branch, type: :string, default: "main"
  def push(locale)
    I28s::Cli::Push.new(locale, branch: options[:branch]).call
  end

  desc "pull", "Pulls translations from i28s"
  option :inplace, type: :boolean, default: false
  option :branch, type: :string, default: "main"
  def pull(locale)
    I28s::Cli::Pull.new(locale, inplace: options[:inplace], branch: options[:branch]).call
  end
end

I28sExe.start(ARGV)
