require 'mime/types'
require 'json'

class GithubProxy
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] =~ %r[/github/([a-z0-9_-]+/[a-z0-9_-]+)/file/([a-z0-9_-]+)/(.+)]
      repo = $1
      rev = $2
      file = $3

      tags = JSON.parse(`curl http://github.com/api/v2/json/repos/show/#{repo}/tags`)
      tags = (tags && tags['tags']) ? tags['tags'].keys : []

      rev = nil unless rev =~ /^HEAD|[0-9a-f]{40}$/ || tags.include?(rev)
      return [404, {}, "Invalid revision"] unless rev

      res = `curl https://github.com/#{repo}/raw/#{rev}/#{file}`
      return [404, {}, "Invalid file or revision"] unless $?.success?

      #TODO: Fix this
      type = nil # params[:type]
      unless type && type.include?('/')
        type = MIME::Types.type_for(type || file)
        type = type && type.first ? type.first.content_type : nil
      end

      [200, { 'Content-Type' => type, 'Cache-Control' => 'public, max-age=3155760000' }, res]
    else
      @app.call(env)
    end
  end
end
