require 'execjs'
module ReactRuby
  module JSX
    def self.context
      @context||=ExecJS.compile (JSCode.jsx)
    end

    def self.transform(jsx)
      result = context.call('JSXTransformer.transform', jsx)
      result["code"]
    end
  end
end
