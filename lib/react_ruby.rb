require 'react/source'
require 'execjs'
require 'react_ruby/jsx'

module ReactRuby
  module JSCode
    def self.read(filename)
      path = React::Source.bundled_path_for(filename)
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
      compile(config)
    end

    def compile(config = {})
      @config = ReactRuby.config.merge(config)
      jsx = @config[:jsx]
      jsx = JSX.transform(jsx) if jsx
      @context = ExecJS.compile(<<-JS)
        if('undefined' === typeof global)
          var global = this;
        #{@config[:react]}
        #{jsx}
        #{@config[:js]}
      JS
    end

    def render(jsx)
      @context.eval("React.renderToString(#{JSX.transform(jsx)})")
    end

    def inspect
      "#<#{self.class.name}:#{self.object_id} ... >"
    end
  end

  class << self
    attr_accessor :config, :renderer

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
