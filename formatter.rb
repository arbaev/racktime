class Formatter
  TIME_FORMATS = { 'year' => '%Y',
                   'month' => '%m',
                   'day' => '%d',
                   'hour' => '%H',
                   'minute' => '%M',
                   'second' => '%S' }.freeze

  attr_reader :invalid_formats

  def initialize(formats)
    @formats = formats.split(',')
    @valid_formats, @invalid_formats = formatted
  end

  def valid?
    @invalid_formats.empty?
  end

  def formatted_time(separator = '-')
    Time.now.strftime(format_string.join(separator))
  end

  private

  def format_string
    @valid_formats.map { |f| TIME_FORMATS[f] }
  end

  def formatted
    @formats.partition { |f| TIME_FORMATS.key?(f) }
  end
end
