require 'thread'
require 'net/http'

module Strobe
  module Middleware
    class Proxy

      # A wrapper around the Net/HTTP response body
      # that allows rack to stream the result down
      class Body
        def initialize(queue)
          @queue = queue
        end

        def each
          while chunk = @queue.pop
            if Exception === chunk
              raise chunk
            else
              yield chunk
            end
          end
        end
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] =~ proxy_path
          host, port = $1.split(':')

          queue = run_request(env, host, ( port || 80 ).to_i, $2 || '/')

          msg = queue.pop

          if Exception === msg
            raise msg
          else
            [ msg[0], msg[1], Body.new(queue) ]
          end
        else
          @app.call(env)
        end
      end

    private

      def proxy_path
        %r[/_strobe/proxy/([^/]+)(/.*)?$]
      end

      KEEP = [ 'CONTENT_LENGTH', 'CONTENT_TYPE' ]

      def run_request(env, host, port, path)
        queue = Queue.new

        if env['CONTENT_LENGTH'] || env['HTTP_TRANSFER_ENCODING']
          body = env['rack.input']
        end

        unless env['QUERY_STRING'].blank?
          path += "?#{env['QUERY_STRING']}"
        end

        http = Net::HTTP.new(host, port)
        http.read_timeout = 60
        http.open_timeout = 60

        request = Net::HTTPGenericRequest.new(
          env['REQUEST_METHOD'], !!body, true, path,
          env_to_http_headers(env))

        request.body_stream = body if body

        Thread.new do
          begin
            http.request(request) do |response|
              hdrs = {}
              response.each_header do |name, val|
                hdrs[name] = val
              end

              queue << [ response.code.to_i, hdrs ]

              response.read_body do |chunk|
                queue << chunk
              end

              queue << nil
            end
          rescue Exception => e
            queue << e
          end
        end

        queue
      end

      def env_to_http_headers(env)
        {}.tap do |hdrs|
          env.each do |name, val|
            next unless name.is_a?(String)
            next if     name == 'HTTP_HOST'
            next unless name =~ /^HTTP_/ || KEEP.include?(name)

            hdrs[ headerize(name) ] = val
          end
        end
      end

      def headerize(str)
        parts = str.gsub(/^HTTP_/, '').split('_')
        parts.map! { |p| p.capitalize }.join('-')
      end
    end
  end
end
