require 'botinsta'

bot = Botinsta.new ({ username: 'YOUR_USERNAME',
                      password: 'YOUR_PASSWORD',
                      tags:              ['photography','vsco','b&w'],
                      likes_per_tag:     60,
                      tag_blacklist:     ['nsfw','sexy','hot'],
                      unfollows_per_run: 200,
                      follows_per_tag:   10
})

bot.start
