require 'react_ruby/renderer'
require 'react_ruby/jscode'

module ReactRuby
  class << self
    attr_accessor :config, :renderer

    def compile(params = {})
      @renderer = Renderer.new(params)
    end

    def render(jsx)
      raise 'It must compile context bofore rendering.' unless @renderer
      @renderer.render(jsx)
    end

    def render_element(element, props)
      raise 'It must compile context bofore rendering.' unless @renderer
      @renderer.render_element(jsx)
    end
  end

  self.config ||= {
    react: JSCode.react
  }
end
