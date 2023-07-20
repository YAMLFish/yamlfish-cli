#!/usr/bin/env ruby
# frozen_string_literal: true

require "thor"
require_relative "../lib/i28s/cli"

class I28sExe < Thor
  desc "push", "Pushes translations to i28s"
  def push(locale)
    I28s::Cli::Push.new(locale).call
  end
end

I28sExe.start(ARGV)
