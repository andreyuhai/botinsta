require 'botinsta'

bot = Botinsta.new ({ username: 'YOUR_USERNAME',
                      password: 'YOUR_PASSWORD',
                      tags:              ['photography','vsco','b&w'],
                      tag_blacklist:     ['nsfw','sexy','hot'],
                      likes_per_tag:     60,
                      unfollows_per_run: 200,
                      follows_per_tag:   10,
                      unfollow_threshold:  { seconds: 0,
                                             minutes: 0,
                                             hours:   1,
                                             days:    0
                      }
})

bot.start
