# JJDecoder

Ruby version of the jjdecode function for JJEncoded string.

[JJEncode](http://utf-8.jp/public/jjencode.html) is originally made by @hasegawayosuke. 

Is a Ruby port of the https://github.com/jacobsoo/Decoder-JJEncode library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jjdecoder'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install jjdecoder
```

## Usage

```ruby
encoded_str = '-encode-string-'
jj = JJDecoder.new(encoded_str)
decoded_str = jj.decode
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mamantoha/jjdecoder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License and Author

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Copyright (c) 2016 by Anton Maminov