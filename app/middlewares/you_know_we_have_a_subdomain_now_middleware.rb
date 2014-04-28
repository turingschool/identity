class YouKnowWeHaveASubdomainNowMiddleware
  MovedPermanentlyCode = 301

  def initialize(app, attributes)
    self.app  = app
    self.from = attributes.fetch :from
    self.to   = attributes.fetch :to
  end

  def call(env)
    request = Rack::Request.new(env)
    if request.base_url == from
      location = to + request.path
      [MovedPermanentlyCode, {"Location" => location}, []]
    else
      app.call env
    end
  end

  private

  attr_accessor :app, :from, :to
end
