# Some helper functions for the bot.
module Helpers

  def print_time_stamp
    print "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\t"
  end

  def print_success_message(**params)
    action = case params[:action]
             when :like     then 'liked media'
             when :unlike   then 'unliked media'
             when :follow   then 'followed user'
             when :unfollow then 'unfollowed user'
             when :comment  then 'commented on media'
             end
    success_string = "Successfully #{action} ##{params[:number]} ".colorize(:green) + params[:data].to_s
    print_time_stamp
    puts success_string
  end

  def print_error_message(**params)
    action = case params[:action]
             when :like     then 'like media'
             when :unlike   then 'unlike media'
             when :follow   then 'follow user'
             when :unfollow then 'unfollow user'
             when :comment  then 'comment on media'
             end
    error_string = "There was an error trying to #{action} ".colorize(:red) + params[:data].to_s
    print_time_stamp
    puts error_string

  end

  def print_login_message(**params)
    result = case params[:result]
             when :success  then 'Successfully logged in as '
             when :error    then 'There was an error trying to login as '
             end
    print_time_stamp
    puts result.colorize(:red) + params[:username]
  end

  def print_try_message(**params)
    action = case params[:action]
             when :login    then 'Trying to login ...'
             when :logout   then 'Trying to logout ...'
             when :like     then 'Trying to like media '
             when :unlike   then 'Trying to unlike media '
             when :follow   then 'Trying to follow user '
             when :unfollow then 'trying to unfollow user '
             end
    print_time_stamp
    puts action.colorize(:light_red) + "#{params[:data].to_s unless params[:data].nil?}"
    sleep(1)
  end

  def print_action_sum
    string =  'Liked: ' + @total_likes.to_s.colorize(:red) +
              ' Followed: ' + @total_follows.to_s.colorize(:red) +
              ' Unfollowed: ' + @total_unfollows.to_s.colorize(:red)
    # TODO: Comments!
    print_time_stamp
    puts string
  end

  def print_tag_message(tag)
    print_time_stamp
    puts 'Current tag is set to '.colorize(:blue) + '#' + tag
  end

  def sleep_rand(min, max)
    sleep_time = rand(min..max)
    sleep(1)
    print_time_stamp
    puts "Sleeping for #{sleep_time - 1} seconds ...".colorize(:red)
    sleep(sleep_time - 1)
  end

  def handle_database_creation
    database = Sequel.sqlite('./actions_db.db') # memory database, requires sqlite3
    database.create_table? :"#{@username}_follows" do
      primary_key :id
      String  :user_id
      String  :username
      Time    :follow_time
    end
    database.create_table? :"#{@username}_likes" do
      primary_key :id
      String :media_id
      String :user_id
      String :shortcode
      Time   :like_time
    end
    @table_follows  = database[:"#{@username}_follows"]
    @table_likes    = database[:"#{@username}_likes"]
  end

  def refresh_db_related
    return if @table_follows.empty?

    @first_db_entry = @table_follows.first
    @last_follow_time = @first_db_entry[:follow_time]
  end

  def delete_from_db(user_id)
    # TODO: Think of a better way, this is not DRY
    @table_follows.where(user_id: user_id).delete
  end

  def one_day_past?(last_time)
    ((Time.now - last_time) / 86_400) >= 1
  end
end