require 'json'
require 'execjs'
require 'react_ruby/jsx'

module ReactRuby
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

    def render_element(element, props)
      @context.eval("React.renderToString(#{element}(#{props.to_json}))")
    end

    def inspect
      "#<#{self.class.name}:#{self.object_id} ... >"
    end
  end
end
