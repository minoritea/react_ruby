require 'react_ruby/version'
require 'execjs'

require 'react_ruby/jsx'

module ReactRuby
  module JSCode

    def self.read(filename)
      path = File.expand_path(
        File.join('../../vendor/assets/javascripts', filename),
        __FILE__)
      ::IO.read(path)
    end

    def self.react
      @react ||= read('react.min.js')
    end

    def self.jsx
      @jsx ||= read('JSXTransformer.js')
    end
  end

  class Renderer
    def initialize(config = {})
      @config = ReactRuby.config.merge(config)
      compile
    end

    def compile
      jsx = @config[:jsx]
      jsx = JSX.transform(jsx) if jsx
      @context = ExecJS.compile(<<-JS)
        var global = global || this;
        #{@config[:react]}
        #{jsx}
        #{@config[:js]}
      JS
    end

    def render(jsx)
      @context.eval("React.renderToString(#{JSX.transform(jsx)})")
    end
  end

  class << self
    attr_accessor :config
    def default_renderer
      @renderer
    end

    def compile(params = {})
      @renderer = Renderer.new(params)
    end

    def render(jsx)
      raise 'It must compile context bofore rendering.' unless @renderer
      @renderer.render(jsx)
    end
  end
  self.config ||= {
    react: JSCode.react
  }
end
