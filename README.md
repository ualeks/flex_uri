# FlexUri

FlexUri is a versatile and modern gem for crafting and manipulating URIs in Ruby. Its intuitive, fluent interface provides a seamless way to build, update, and combine URI components, making it ideal for managing query parameters, paths, and URI segments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flex_uri'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install flex_uri
```

## Usage

Here's a basic example of how to use FlexUri:

```ruby
require 'flex_uri'

# Create a new FlexUri instance
url = FlexUri.create('https://example.com/path')

# Add and modify the URI components
url.add_path('new_path')
  .insert_query(q: 'search term', page: 1)
  .scheme('http')
  .host('new.example.com')
  .port(8080)
  .remove_query_key(:q)
  .update_query(q: 'new search term', page: 2)
  .set_fragment('section-1')
  .build
```

## Available Methods

Here's a list of available methods for manipulating URIs with FlexUri, along with brief explanations:

- `add_path(path)`: Append a path segment to the URI's existing path.
- `insert_query(params)`: Insert query parameters into the URI's existing query string.
- `remove_query_key(key)`: Remove a specific key from the URI's query string.
- `update_query(params)`: Update the URI's query string with new parameters.
- `scheme(scheme, default: nil)`: Set the URI's scheme (e.g., 'HTTP', 'HTTPS').
- `host(host, default: nil)`: Set the URI's host (e.g., 'example.com').
- `port(port, default: nil)`: Set the URI's port number.
- `user(user)`: Set the URI's user info.
- `pass(pass)`: Set the URI's password info.
- `fragment(fragment)`: Set the URI's fragment identifier.
- `query_string(query_string)`: Set the entire query string of the URI.
- `path(path)`: Set the URI's path.
- `truncate_path(path)`: Set the URI's path and remove query and fragment parts.
- `order_query_params`: Order the URI's query parameters alphabetically.
- `encode_uri`: Encode the URI.
- `resolve_relative(relative_url)`: Resolve a relative URI against the current URI.
- `parse(url)`: Parse a new URL and update the current URI instance.
- `validate`: Validate the URI by ensuring it has a scheme and a host.
- `build`: Generate the final URI string.

## Compatibility

FlexUri is compatible with different Ruby versions and Rails projects.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ualeks/flex_uri. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ualeks/flex_uri/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
