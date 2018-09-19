# Botinsta [![Build Status](https://travis-ci.com/andreyuhai/botinsta.svg?branch=master)](https://travis-ci.com/andreyuhai/botinsta) [![Gem Version](https://badge.fury.io/rb/botinsta.svg)](https://badge.fury.io/rb/botinsta)

## Description

This is a **tag-based Instagram bot** I've created under the influence of other cool Instagram bots [instabot.py](https://github.com/instabot-py) and [instabot.rb](https://github.com/eVanilla/instabot.rb/) to improve my Ruby skills.

#### What do you mean tag-based?!

Well, tag-based means that the bot works based on solely the tags you specified. You specify the tags you want the bot to like medias and follow users from and it loops through all tags liking a number of medias specified by you and also following the owners of medias it liked. See [how it works](#usage--how-it-works)

## Installation

Since this bot uses a local database to track follows and media likes. You need to install `libsqlite3-dev`.

    $ sudo apt-get install libsqlite3-dev

Add this line to your application's Gemfile:

```ruby
gem 'botinsta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install botinsta

## Features

  * Follow
  * Like
  * Unfollow people followed after a day. Creates a local database for that matter.
  * Avoid liking medias which has blacklisted tags

## Features to come

  * Comments
  * Unlike medias
  * Avoid following blacklisted users

I am still not sure what else to add but if you have any idea don't hesitate to hit me up or send me a pull request!

## Usage & How it works

You can use the bot simply like below. It already has default parameters so you could just input your `username` and `password` and let it use the defaults for the rest.

```ruby
require 'botinsta'

bot = Botinsta.new ({ username: 'YOUR_USERNAME',
                      password: 'YOUR_PASSWORD',
                      tags:              ['photography','vsco','fotografia'],
                      tag_blacklist:     ['nsfw','sexy','hot'],
                      likes_per_tag:     20,
                      unfollows_per_run: 200,
                      follows_per_tag:   10
})

bot.start
```

**IMPORTANT:** First of all this bot doesn't work on a daily basis. It just loops through all the tags given to it and accomplishes its task. This is all it does. If you want to reuse it, you should run it again or look for other automation techniques to run this bot everyday (i.e. crontab or some other techniques) until I figure out a logical method to add this feature. I will also add techniques of how to automate this bot using other automation techniques really soon.  

---

The bot loops through each tag liking as many images as `@likes_per_tag` and following as many users as `@follows_per_tag`.

Liking medias and following users from the tag's first page is easy because all you have to do is:

    https://instagram.com/explore/tags/YOURTAG/?__a=1

to navigate to above link and get the JSON string then parse it accordingly
to extract necessary information (i.e. media ID, owner ID).

It gets complicated when you liked all the medias on the first page and need to get the next page—with next page I am referring to when you scroll down the page to load more content—to continue extracting data, liking medias & following users. So we can do the same with a `GET` request instead since we are using `Mechanize` for automation.

To get the next page you need two things:

  * query\_id (query\_hash)
  * end\_cursor

which will be used in GET requests to get the JSON string for the next page.

An example of the link:

    https://www.instagram.com/graphql/query/?query_hash=1780c1b186e2c37de9f7da95ce41bb67&variables={"tag_name":"photography","first":4,"after":"AQAiksCP1Uzk5-bXZ3qnwUsA89YRn1LBia9_yDFeWm5S1KTfzyU8eH8EFjq8LPuFOemdkRjzWb8_5vmyQ8Gnj-sTCfVGwRHs8WoKhPtBncmLbg"}

As you can see we need to provide the query\_id (query\_hash) and end\_cursor (the same as `after`) in the link.

We get the above parameters with the help of methods in the module [Pages](https://www.rubydoc.info/github/andreyuhai/botinsta/master/Pages).

The rest is just doing the same controls in a loop to like, follow & unfollow (just for now). 

TODO: More detailed explanation will be here.

## Documentation

  * [Documentation](https://www.rubydoc.info/github/andreyuhai/botinsta/master) 

I will eventually complete all method descriptions and usages. You can help me if you would like to!

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

If you like the bot and want to see the new features very soon, please do not forget to star the repo to let me now you are interested. Boost me!  :rocket:  :blush:

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
