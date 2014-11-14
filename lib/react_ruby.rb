require "react_ruby/version"
require 'execjs'

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

  def self.config
    @config ||= {
      jsx: JSCode.jsx,
      react: JSCode.react
    }
  end

  class Renderer
    def initialize(config = {})
      @config = ReactRuby.config.merge(config)
      compile
    end

    def compile
      @context = ExecJS.compile(<<-JS)
        var global = global || this;
        #{@config[:react]}
        #{@config[:jsx]}
        #{@config[:src]}
        if(!renderReactViewToRuby){
          function renderReactViewToRuby(jsx){
            var js = JSXTransformer.transform(jsx);
            var el = eval(js.code);
            return React.renderToString(el);
          }
        }
      JS
    end

    def render(jsx)
      @context.call('renderReactViewToRuby', jsx)
    end
  end
end
