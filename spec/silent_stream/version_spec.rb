# frozen_string_literal: true

require "anonymous_loader"
RSpec.describe SilentStream::Version do
  it_behaves_like "a Version module", described_class

  it "executes the version file for coverage without redefining constants" do
    paths = [
      File.expand_path("../../lib/silent_stream/version.rb", __dir__),
      File.expand_path("../../lib/silent_stream/version_gem.rb", __dir__)
    ].select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::SilentStream::Version::VERSION).to eq(described_class::VERSION)
  end
end
