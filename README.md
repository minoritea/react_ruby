# ReactRuby

ReactRuby is a template engine compiling react.js template
  on ruby servers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'react_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install react_ruby

## Usage

if you wrote react templates to view.jsx:
```jsx
 Post = React.createClass({
  render: function(){
    return <div>{this.props.body}</div>;
  }
});
```

in ruby:
```ruby
require 'react_ruby'

template = File.read('view.jsx')
ReactRuby.compile(jsx: template)
ReactRuby.render('<Post body="Hello, world!" />')
#=> "<div data-reactid=\".n7s1kw8feo\" data-react-checksum=\"-972549822\">Hello, world!</div>"
```

Note: at first, you must compile context once, then you can invoke #render method at any time.

## Contributing

1. Fork it ( https://github.com/minoritea/react_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
