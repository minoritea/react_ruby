require 'execjs'
require 'react_ruby/jscode'

module ReactRuby
  module JSX
    def self.context
      @context||=ExecJS.compile ('var global = global || this;' + JSCode.jsx)
    end

    def self.transform(jsx)
      result = context.call('JSXTransformer.transform', jsx)
      result["code"]
    end
  end
end
