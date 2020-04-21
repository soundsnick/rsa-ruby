require 'socket'
require 'uri'
# Require algorithmic files
require './cipher.rb'
require './generate_keys.rb'

server = TCPServer.new '127.0.0.1', 8888
@params = {}


loop do
  # Import keys
  public_key = File.open("./keys/public.key")
  public_keys = public_key.read.split(',').map(&:to_i)
  public_keys_plain = public_keys.join(",")
  public_key.close

  private_key = File.open("./keys/private.key")
  private_keys = private_key.read.split(',').map(&:to_i)
  private_keys_plain = private_keys.join(",")
  private_key.close

  session = server.accept
  session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"

  if request = session.gets
    route = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp

    @par_count = false

    # Get params from URL
    def make_params(route)
      get_params = route.split("?")
      if get_params.length > 0
        get_params = get_params[1].split("&")
        get_params.each do |param|
          get = param.split("=")
          @params[get[0]] = get[1]
        end
      end
    end

    if route.index("?")
      make_params route
      @par_count = true
    end
    if not @par_count and not route.index("favicon")
      @params = {}
    end

    # Basic routing and controllers
    if route.split("?")[0] == "encrypt"
      encrypted = encrypt(*public_keys, @params['message'])
      session.print URI.unescape(encrypted)
    elsif route.split("?")[0] == "decrypt"
      decrypted = decrypt(*private_keys, @params['message'])
      session.print URI.unescape(decrypted)
    elsif route.split("?")[0] == "regenerate"
      new_keys = generate_keys
      session.print URI.unescape(new_keys)
    else
      html = File.open("./gui/index.html")
      css = File.open("./gui/main.css")
      styles = css.read
      plain_html = html.read.gsub!("{public_key}", "#{public_keys_plain}").gsub!("{private_key}", private_keys_plain).gsub!("{styles}", styles)
      html.close
      css.close
      session.print plain_html
    end
  end

  session.close
end
