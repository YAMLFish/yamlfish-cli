# frozen_string_literal: true

RSpec.describe Yamlfish::Cli do
  it "has a version number" do
    expect(Yamlfish::Cli::VERSION).not_to be nil
  end
end
