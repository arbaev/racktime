require_relative 'formatter'

class App
  APP_PATH = '/time'.freeze

  def call(env)
    request = Rack::Request.new(env)

    return wrong_path_response unless request.path == APP_PATH

    return wrong_query_response if request.params['format'].nil?

    ftime = Formatter.new(request.params['format'])

    return wrong_formats_response(ftime.invalid_formats) unless ftime.valid?

    response(200, ftime.formatted_time)
  end

  private

  def response(status, headers = { 'Content-type' => 'text/plain' }, body)
    [status, headers, ["#{body}\n"]]
  end

  def wrong_path_response
    response 404, "Wrong path, nothing here. Try /time"
  end

  def wrong_query_response
    response 400, "Wrong parameter. Try ?format="
  end

  def wrong_formats_response(formats)
    response 400, "Unknown time format #{formats}.
Available formats are: #{Formatter::TIME_FORMATS.keys.join(', ')}"
  end
end
