# frozen_string_literal: true

require "ruby_engine"
require "ruby_version"

# These examples intentionally exercise global stream APIs and output paths.
# rubocop:disable RSpec/Output, Style/GlobalStdStream
RSpec.describe SilentStream do
  let(:test_class) do
    Class.new do
      include SilentStream

      class << self
        def quiet_log(switch, level, logger)
          silence_all(switch, level, logger) do
            logger.debug("some debug")
            logger.error("some error")
          end
        end
      end
    end
  end

  def silence_capture(stream)
    test_class.capture(stream) { yield }
  end

  it "silences logging when enabled" do
    logger = Logger.new($stdout)

    expect(silence_capture(:stdout) { test_class.quiet_log(true, Logger::ERROR, logger) }).to eq("")
  end

  it "does not silence logging when disabled" do
    logger = Logger.new($stdout)

    output = silence_capture(:stdout) { test_class.quiet_log(false, Logger::ERROR, logger) }

    expect(output).to match(/some debug\n.*some error\n/)
  end

  it "silences a stream and restores its position" do
    begin
      old_stream_position = STDOUT.tell
      test_class.silence_stream(STDOUT) { STDOUT.puts "hello world" }

      expect(STDOUT.tell).to eq(old_stream_position)
    rescue Errno::ESPIPE
      skip "stdout is not seekable"
    end
  end

  it "closes the duplicated stream" do
    skip "truffleruby cannot modify this stream" if RubyEngine.truffle?

    stream = StringIO.new
    duplicate = StringIO.new
    allow(stream).to receive(:dup).and_return(duplicate)
    expect(duplicate).to receive(:close)

    test_class.silence_stream(stream) { duplicate.puts "hello world" }
  end

  it "silences both standard streams" do
    begin
      old_stdout_position = STDOUT.tell
      old_stderr_position = STDERR.tell

      test_class.quietly do
        puts "see me, feel me"
        warn "touch me, heal me"
      end

      expect(STDOUT.tell).to eq(old_stdout_position)
      expect(STDERR.tell).to eq(old_stderr_position)
    rescue Errno::ESPIPE
      skip "a standard stream is not seekable"
    end
  end

  it "captures stderr" do
    expect(silence_capture(:stderr) { $stderr.print("STDERR") }).to eq("STDERR")
  end

  it "captures stdout" do
    expect(silence_capture(:stdout) { print("STDOUT") }).to eq("STDOUT")
  end

  it "captures redirected stderr" do
    skip "JRuby capture is flaky" if RubyEngine.jruby?

    expect(silence_capture(:stderr) { system("echo STDERR 1>&2") }).to eq("STDERR\n")
  end

  it "captures redirected stdout" do
    skip "JRuby capture is flaky" if RubyEngine.jruby?

    expect(silence_capture(:stdout) { system("echo STDOUT") }).to eq("STDOUT\n")
  end

  it "reports its version" do
    expect(SilentStream::Version::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  it "finds no Rails logger when Rails is unavailable" do
    hide_const("Rails") if defined?(Rails)

    expect(test_class.send(:silent_stream_logger)).to be_nil
  end

  it "finds the Rails logger when Rails is available" do
    rails_logger = Logger.new(StringIO.new)
    rails = Module.new
    stub_const("Rails", rails)
    allow(rails).to receive(:respond_to?).with(:logger).and_return(true)
    allow(rails).to receive(:logger).and_return(rails_logger)

    expect(test_class.send(:silent_stream_logger)).to be(rails_logger)
  end

  it "returns no logger when Rails has no logger" do
    rails = Class.new
    stub_const("Rails", rails)

    expect(test_class.send(:silent_stream_logger)).to be_nil
  end

  it "temporarily changes and returns a logger level" do
    logger = Logger.new(StringIO.new)
    logger.level = Logger::INFO

    old_level = test_class.send(:silent_stream_reset_logger_level, logger, Logger::ERROR)

    expect(old_level).to eq(Logger::INFO)
    expect(logger.level).to eq(Logger::ERROR)
  end

  it "does not silence when NO_SILENCE is enabled" do
    stub_env("NO_SILENCE" => "true")
    logger = Logger.new($stdout)

    output = silence_capture(:stdout) { test_class.quiet_log(true, Logger::ERROR, logger) }

    expect(output).to match(/some debug\n.*some error\n/)
  end

  it "silences stderr" do
    output = silence_capture(:stderr) { test_class.silence_stderr { warn "hidden" } }

    expect(output).to eq("")
  end

  it "silences stdout and stderr together" do
    output = silence_capture(:stdout) do
      silence_capture(:stderr) do
        test_class.quietly do
          puts "x"
          warn "y"
        end
      end
    end

    expect(output).to eq("")
  end

  # rubocop:disable RSpec/RemoveConst
  it "supports both Windows platform matching branches" do
    original = SilentStream::Extracted::SILENT_STREAM_REGEXP_HAS_MATCH
    original_host_os = RbConfig::CONFIG["host_os"]

    begin
      RbConfig::CONFIG["host_os"] = "mingw"
      expect(test_class.send(:windows_os_test)).to be(true)

      SilentStream::Extracted.send(:remove_const, :SILENT_STREAM_REGEXP_HAS_MATCH)
      SilentStream::Extracted.const_set(:SILENT_STREAM_REGEXP_HAS_MATCH, false)
      RbConfig::CONFIG["host_os"] = "linux"
      expect(test_class.send(:windows_os_test)).to be_falsey
    ensure
      SilentStream::Extracted.send(:remove_const, :SILENT_STREAM_REGEXP_HAS_MATCH)
      SilentStream::Extracted.const_set(:SILENT_STREAM_REGEXP_HAS_MATCH, original)
      RbConfig::CONFIG["host_os"] = original_host_os
    end
  end
  # rubocop:enable RSpec/RemoveConst

  it "evaluates the null-device expression" do
    result = eval("Gem.win_platform? ? 'NUL:' : '/dev/null'", binding, __FILE__, __LINE__)

    expect(result).to satisfy { |value| ["NUL:", "/dev/null"].include?(value) }
  end

  it "warns when stream reopening fails" do
    stream = StringIO.new
    duplicate = StringIO.new
    allow(stream).to receive(:dup).and_return(duplicate)
    allow(stream).to receive(:reopen).with(SilentStream::Extracted::SILENT_STREAM_NULL_DEVICE, "a+")
      .and_raise(StandardError, "fail to reopen")
    allow(stream).to receive(:reopen).with(duplicate)
    expect(stream).to receive(:puts).with(/\[SilentStream\] Unable to silence\. StandardError: fail to reopen/)

    test_class.silence_stream(stream) { stream.write("noop") }
  end

  it "warns when capture reopening fails" do
    expect(STDOUT).to receive(:reopen).with(kind_of(Tempfile)).ordered
    expect(STDOUT).to receive(:reopen).with(kind_of(Tempfile)).ordered.and_raise(StandardError, "boom")
    allow(STDOUT).to receive(:reopen).with(kind_of(IO))

    expect(silence_capture(:stdout) { silence_capture(:stdout) {} }).to be_a(String)
  end

  it "handles a nil logger" do
    expect(test_class.send(:silent_stream_reset_logger_level, nil, Logger::ERROR)).to be_nil
  end

  it "uses true as the previous level when a logger level is nil" do
    logger = instance_double(Logger, level: nil)
    allow(logger).to receive(:level=)

    old_level = test_class.send(:silent_stream_reset_logger_level, logger, Logger::WARN)

    expect(old_level).to be(true)
    expect(logger).to have_received(:level=).with(Logger::WARN)
  end

  it "restores the logger level when the block raises" do
    logger = Logger.new(StringIO.new)
    logger.level = Logger::WARN

    expect do
      test_class.silence_all(true, Logger::ERROR, logger) { raise "boom" }
    end.to raise_error(RuntimeError, "boom")

    expect(logger.level).to eq(Logger::WARN)
  end

  it "handles capture cleanup errors" do
    temp = Tempfile.new("stdout")
    begin
      allow(Tempfile).to receive(:new).with("stdout").and_return(temp)
      allow(temp).to receive(:close).and_raise(StandardError)
      allow(temp).to receive(:unlink).and_raise(StandardError)

      expect(silence_capture(:stdout) { print "hi" }).to eq("hi")
    ensure
      begin
        temp&.close
      rescue
        nil
      end
    end
  end

  it "runs capture cleanup guards when stream setup fails" do
    bad = Object.new
    allow(bad).to receive(:to_s).and_raise("boom to_s")

    expect { test_class.capture(bad) {} }.to raise_error(TypeError)
  end

  it "runs capture cleanup guards when the tempfile is missing" do
    allow(Tempfile).to receive(:new).with("stdout").and_return(nil)

    expect { test_class.capture(:stdout) { print "hi" } }.to raise_error(NoMethodError)
  end

  it "handles tempfile unlink errors" do
    temp = Tempfile.new("stdout")
    begin
      allow(Tempfile).to receive(:new).with("stdout").and_return(temp)
      allow(File).to receive(:unlink).with(temp.path).and_raise(StandardError)

      expect(silence_capture(:stdout) { print "hi" }).to eq("hi")
    ensure
      begin
        temp&.close
      rescue
        nil
      end
    end
  end
end
# rubocop:enable RSpec/Output, Style/GlobalStdStream
