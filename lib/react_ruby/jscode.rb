require 'react/source'
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
end
