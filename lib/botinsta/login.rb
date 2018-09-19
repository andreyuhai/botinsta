# Contains login and logout methods for the bot.
module Login

  # Login method to log the user in.
  # Prints success message on successful login,
  #   error message otherwise.
  # @example Login example
  #   bot.login # => 2018-09-19 17:39:45	Trying to login ...
  #             # => 2018-09-19 17:39:47	Successfully logged in as andreyuhai
  def login
    @agent = Mechanize.new

    # Navigate to classic login page
    login_page = @agent.get 'https://www.instagram.com/accounts/login/?force_classic_login'

    # Get the login form
    login_form = login_page.forms.first

    # Fill in the login form
    login_form['username'] = @username
    login_form['password'] = @password

    # Submit the form and if couldn't login raise an exception.
    print_try_message(action: :login)
    response = login_form.submit
    if response.code != 200 && response.body.include?('not-logged-in')
      login_status = false
    else
      print_login_message(result: :success, username: @username)
      login_status = true
    end
    raise StandardError unless login_status
  rescue StandardError
    print_login_message(result: :error, username: @username)
    # TODO: logger to log these kind of stuff
    exit
  end

  # Prints action sum and then logs the user out.
  # @example Logout example
  #   bot.logout # => 2018-09-19 17:41:11	Liked: 0 Followed: 0 Unfollowed: 0
  #              # => 2018-09-19 17:41:11	Trying to logout ...
  def logout
    print_action_sum
    print_try_message(action: :logout)
    @agent.get 'https://instagram.com/accounts/logout/'
  end
end