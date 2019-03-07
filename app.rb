class App
  APP_PATH = '/time'.freeze
  TIME_FORMATS = { 'year' => '%Y',
                   'month' => '%m',
                   'day' => '%d',
                   'hour' => '%H',
                   'minute' => '%M',
                   'second' => '%S' }.freeze

  def call(env)
    return wrong_path_response if env['REQUEST_PATH'] != APP_PATH

    query = Rack::Utils.parse_query(env['QUERY_STRING'])

    return wrong_query_response if query['format'].nil?

    wrong_formats = []
    format = query['format'].split(',')

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
