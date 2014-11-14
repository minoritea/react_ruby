require 'test/unit'
require 'react_ruby'

class JSXTest < Test::Unit::TestCase
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
      this.Post = React.createClass({displayName: 'Post',
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

class RendererTest < Test::Unit::TestCase
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
end

class ReactRubyTest < Test::Unit::TestCase
  def setup
    ReactRuby.renderer = nil
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
