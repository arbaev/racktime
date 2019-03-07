class App
  APP_PATH = '/time'.freeze
  TIME_FORMATS = { 'year' => '%Y',
                   'month' => '%m',
                   'day' => '%d',
                   'hour' => '%H',
                   'minute' => '%M',
                   'second' => '%S' }.freeze

  def call(env)
    request = Rack::Request.new(env)

    return wrong_path_response unless request.path == APP_PATH

    return wrong_query_response if request.params['format'].nil?

    format = request.params['format'].split(',')

    wrong_formats = []

    ftime = format.map do |f|
      requested_format = TIME_FORMATS[f]

      wrong_formats.push(f) if requested_format.nil?

      requested_format
    end

    return wrong_formats_response(wrong_formats) unless wrong_formats.empty?

    response_string = Time.now.strftime(ftime.join('-'))

    response(200, text_plain, response_string)
  end

  private

  def response(status, type, body)
    [status, type, [body]]
  end

  def text_plain
    { 'Content-type' => 'text/plain' }
  end

  def wrong_path_response
    response(404, text_plain, "Wrong path, nothing here. Try /time")
  end

  def wrong_query_response
    response(400, text_plain, "Wrong parameter. Try format=year%2Cmonth%2Cday")
  end

  def wrong_formats_response(formats)
    response(400, text_plain, "Unknown time format #{formats}")
  end
end
