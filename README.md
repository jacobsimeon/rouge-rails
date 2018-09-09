# Rouge::Rails

Give rails the power to render code samples in [rouge][rouge] colored glory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rouge-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rouge-rails

## Setup

Stylesheets with standard colorschemes are available in the asset pipeline.
Include one colorscheme in your `application.scss`:

```scss
@import "rouge/github";
```

Or include all colorschemes:

```scss
@import "rouge";
```

## Usage

### Render a beautifully highlighted code example in a rails view

1. Place the code sample in a partial somewhere in your views directory and use
".rouge" as the file extension, e.g.:

```ruby
# app/views/home/_code_sample.rouge
class MyCode
  def example
    puts "hello world"
  end
end
```

2. Render the code sample in your view:
```erb
# app/views/home/index.html.erb
<%= render "code_sample", language: :ruby %>
```

### Configure the default colorscheme

Add this code to an initializer in your app
```ruby
# config/initializers/rouge.rb
Rouge::Rails.configure do |config|
  config.default_colorscheme = "solarized-dark"
end
```

### Specify a colorscheme for a single partial

```
<%= render "code_sample", language: :ruby, colorscheme: "github" %>
```

### You can even use ERB inside a rouge template

```ruby
# app/controllers/home_controller.rb
def index
  @greeting = "hello world"
end

# app/views/home/_code_sample.rouge
class MyCode
  def example
    puts "<%= @greeting %>"
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jacobsimeon/rouge-rails.


## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).


[rouge]: https://github.com/jneen/rouge
