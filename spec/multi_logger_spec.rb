require 'logstash-logger'

describe LogStashLogger::MultiLogger do
  include_context 'device'

  # Create a MultiLogger writing to both STDOUT and a StringIO
  subject { multi_logger }

  it { is_expected.to be_a LogStashLogger::MultiLogger }

  it "has multiple loggers" do
    expect(subject.loggers.count).to eq(2)
  end

  it "has one logger per output" do
    expect(subject.loggers[0].device).to be_a LogStashLogger::Device::Stdout
    expect(subject.loggers[1].device).to be_a LogStashLogger::Device::IO
  end

  it "allows a different formatter for each logger" do
    expect(subject.loggers[0].formatter).to be_a ::Logger::Formatter
    expect(subject.loggers[1].formatter).to be_a LogStashLogger::Formatter::JsonLines
  end

  it "logs to all loggers" do
    subject.loggers.each do |logger|
      expect(logger).to receive(:info).with("test")
    end

    multi_logger.info("test")
  end

  describe "#formatter=" do
    it "doesn't update the formatter if it's already set" do
      subject.loggers.each do |logger|
        logger.formatter = :json_lines
      end

      subject.formatter = :json

      subject.loggers.each do |logger|
        expect(logger.formatter).to eq(:json_lines)
      end
    end
  end
end
