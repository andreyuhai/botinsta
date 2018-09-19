# Botinsta

This is an Instagram bot I've created under the influence of other cool Instagram bots [instabot.py](https://github.com/instabot-py) and [instabot.rb](https://github.com/eVanilla/instabot.rb/) to improve my Ruby skills.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'botinsta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install botinsta

## Usage

You can use the bot simply like below. It already has default parameters so you could just input your `username` and `password` and let it use the defaults for the rest.

```ruby
require 'botinsta'

bot = Botinsta.new ({ username: 'YOUR_USERNAME',
                      password: 'YOUR_PASSWORD',
                      tags:              ['photography','vsco','fotografia'],
                      likes_per_tag:     20,
                      tag_blacklist:     ['nsfw','sexy','hot'],
                      likes_per_day:     1000,
                      unfollows_per_day: 200,
                      follows_per_day:   250,
                      follows_per_tag:   10
})

bot.start
```

## Documentation

You can find the documentation of this bot on [rubydoc](https://www.rubydoc.info/github/andreyuhai/botinsta/master). I will eventually complete all method descriptions and usages. You can help me if you would like to!

## Features

  * Follow
  * Like
  * Unfollow people followed after a day

## Features to come

  * Comments
  * Unlike medias

I am still not sure what else too add but if you have any idea don't hesitate to hit me up or send me a pull request!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Gems used

  * Colorize
  * Hashie
  * Json
  * Mechanize
  * Nokogiri
  * Sequel
  * Sqlite3

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andreyuhai/botinsta.

If you like the bot and want to see the new features very soon, please do not forget to star the repo to let me now you are interested. Boost me! :)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
