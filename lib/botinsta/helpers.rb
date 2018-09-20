# Some helper methods
# to use in main methods for the bot.
module Helpers

  # Prints out the current time
  # @example
  #   print_time_stamp # => "2018-09-19 12:14:43"
  def print_time_stamp
    print "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\t"
  end

  # Prints success message for a specified action.
  #
  # @option params [Symbol] :action The action performed.
  # @option params [String] :data The id that the action is performed on.
  # @option params [Integer] :number The number of times that the action has been performed.
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

  # Prints error message for a specified action.
  #
  # @option params [Symbol] :action The action performed.
  # @option params [String] :data The id that the action is performed on.
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

  # Prints login status message for the account
  #
  # @option params [Symbol] :result Login status
  # @option params [String] :username
  def print_login_message(**params)
    result = case params[:result]
             when :success  then 'Successfully logged in as '
             when :error    then 'There was an error trying to login as '
             end
    print_time_stamp
    puts result.colorize(:red) + params[:username]
  end

  # Prints messages when trying to take some action.
  #
  # @option params [Symbol] :action The action that the bot is trying to take.
  # @option params [String, Integer] :data The data which will be
  #   affected by the specified action.
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

  # Prints action sum. Used before logging out.
  #
  # @example
  #   bot.print_action_sum # => 2018-09-19 17:41:11	Liked: 0 Followed: 0 Unfollowed: 0
  def print_action_sum
    string =  'Liked: ' + @total_likes.to_s.colorize(:red) +
              ' Followed: ' + @total_follows.to_s.colorize(:red) +
              ' Unfollowed: ' + @total_unfollows.to_s.colorize(:red)
    print_time_stamp
    puts string
  end

  # Prints out when the current is set to some specified tag.
  #
  # @param tag [String] current tag.
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

  # Handles the creation and connection of a database and its tables.
  # Sets @table_follows and @table_likes to the related tables for further use.
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

  # Reassigns the database related variables to the first entry
  # in the database.
  # Used after a deletion from the database.
  def refresh_db_related
    return if @table_follows.empty?

    @first_db_entry = @table_follows.first
    @last_follow_time = @first_db_entry[:follow_time]
  end

  # The method that is used to delete a user from the database
  # after unfollowing the user.
  #
  # @todo This method needs to be replaced with a better and DRY one.
  # @param user_id [String, Integer] id of the user to be unfollowed.
  def delete_from_db(user_id)
    @table_follows.where(user_id: user_id).delete
  end

  # Calculates whether the given threshold is past or not to
  # start unfollowing users from the database.
  #
  # @param last_time [Time] a Time instance, used with @last_follow_time.
  # @return [Boolean] true if a day is past since
  #   the first follow entry in the database, false otherwise.
  def unfollow_threshold_past?(last_time)
    days    = @unfollow_threshold[:days]    ||= 0
    hours   = @unfollow_threshold[:hours]   ||= 0
    minutes = @unfollow_threshold[:minutes] ||= 0
    seconds = @unfollow_threshold[:seconds] ||= 0

    total_in_seconds = days * 86_400 + hours * 3600 + minutes * 60 + seconds
    ((Time.now - last_time) / total_in_seconds) >= 1
  end
end