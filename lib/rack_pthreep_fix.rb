class RackPthreepFix
  def initialize app
    @app = app
  end

  def call env
    res = @app.call(env)
    res[1]['P3P'] = 'CP="http://bit.ly/1kn927n"'
    res
  end
end
