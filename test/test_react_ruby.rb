require 'test/unit'
require 'therubyracer'
require 'react_ruby'
require 'execjs'

module TestCases
  module JSXTestCase
    def setup
      set_runtime
    end

    def set_runtime
      ExecJS.runtime = ExecJS::Runtimes::RubyRacer
    end

    def test_react_method
      jsx = '<div>hello</div>'
      assert_equal('React.createElement("div", null, "hello")',
        ReactRuby::JSX.transform(jsx))
    end

    def test_react_method_with_multi_line_jsx
      jsx = <<-JSX
        this.Post = React.createClass({
          render: function(){
            return <div>
              <Body message={"hello"}/>
              Hello
              </div>;
          }
        });
      JSX
      assert_equal(<<-JSX, ReactRuby::JSX.transform(jsx))
        this.Post = React.createClass({displayName: "Post",
          render: function(){
            return React.createElement("div", null, 
              React.createElement(Body, {message: "hello"}), 
              "Hello"
              );
          }
        });
      JSX
    end
  end

  module RendererTestCase
    def setup
      set_runtime
    end

    def set_runtime
      ExecJS.runtime = ExecJS::Runtimes::RubyRacer
    end

    def test_render_with_jsx
      renderer = ReactRuby::Renderer.new(jsx: <<-JSX)
         Test = React.createClass({
           render: function(){
             return <div>{this.props.testMessage}</div>;
           }
         });
      JSX
      assert_match(/<div [^>]+>test<\/div>/,
        renderer.render('<Test testMessage="test"/>'))
    end
    
    def test_render_with_js
      renderer = ReactRuby::Renderer.new(js: <<-JS)
         Test = React.createClass({displayName: 'Test',
           render: function(){
             return React.createElement("div", null, this.props.testMessage);
           }
         });
      JS
      assert_match(/<div [^>]+>test<\/div>/,
        renderer.render('<Test testMessage="test"/>'))
    end

    def test_render_element
      renderer = ReactRuby::Renderer.new(js: <<-JS)
         Test = React.createClass({displayName: 'Test',
           render: function(){
             return React.createElement("div", null, this.props.testMessage);
           }
         });
      JS
      assert_match(/<div [^>]+>test<\/div>/,
        renderer.render_element(:Test, testMessage:'test'))
    end
  end

  module ReactRubyTestCase
    def setup
      set_runtime
      ReactRuby.renderer = nil
    end

    def set_runtime
      ExecJS.runtime = ExecJS::Runtimes::RubyRacer
    end

    def test_renderer
      assert_nil(ReactRuby.renderer)
      ReactRuby.compile
      assert(ReactRuby.renderer)
    end

    def test_render_before_compile
      assert_raise{ReactRuby.render('<div></div>')}
      ReactRuby.compile
      assert_nothing_thrown{ReactRuby.render('<div></div>')}
    end
  end

  def self.create_tests
    constants.each do |module_name|
      next unless module_name =~ /\A(.+)TestCase\z/
      base_name = $~[1]
      m = const_get(module_name)

      next unless m.is_a? Module

      klass = Class.new(Test::Unit::TestCase) do
        include m
      end
      const_set(base_name + 'Test', klass)

      next unless ExecJS::Runtimes::Node.available?

      klass_with_node = Class.new(Test::Unit::TestCase) do
        include m
        def set_runtime
          ExecJS.runtime = ExecJS::Runtimes::Node
        end
      end

      const_set(base_name + 'TestWithNode', klass_with_node)
    end
  end
end

TestCases.create_tests
