# Various actions you can do on Instagram
# and other related methods.
module Actions

  # Likes media given by media id.
  #
  # @param media_id [String]
  # @return [true, false] returns true on success, false otherwise.
  def like_media(media_id)
    url_like = "https://www.instagram.com/web/likes/#{media_id}/like/"
    print_try_message(action: :like, data: media_id)
    begin
      set_request_params
      response = @agent.post url_like, @params, @request_headers
    rescue Mechanize::ResponseCodeError
      return false
    end
    response_data = JSON.parse(response.body)
    response.code == '200' && response_data['status'] == 'ok' ? true : false
  end

  # Unlikes media given by media id.
  #
  # @param media_id [String]
  # @return (see #like_media)
  def unlike_media(media_id)
    url_unlike = "https://www.instagram.com/web/likes/#{media_id}/unlike/"
    print_try_message(action: :unlike, data: media_id)
    begin
      set_request_params
      response = @agent.post url_unlike, @params, @request_headers
    rescue Mechanize::ResponseCodeError
      return false
    end
    response_data = JSON.parse(response.body)
    response.code == '200' && response_data['status'] == 'ok' ? true : false
  end

  # Follows user given by user_id.
  #
  # @param user_id [String]
  # @return (see #like_media)
  def follow_user(user_id)
    url_follow = "https://www.instagram.com/web/friendships/#{user_id}/follow/"
    print_try_message(action: :follow, data: user_id)
    begin
      set_request_params
      response = @agent.post url_follow, @params, @request_headers
    rescue Mechanize::ResponseCodeError
      return false
    end
    response_data = JSON.parse(response.body)
    response.code == '200' && response_data['result'] == 'following' ? true : false
  end

  # Unfollows user given by user_id.
  #
  # @param user_id [String]
  # @return (see #like_media)
  def unfollow_user(user_id)
    url_unfollow = "https://www.instagram.com/web/friendships/#{user_id}/unfollow/"
    print_try_message(action: :unfollow, data: user_id)
    begin
      set_request_params
      response = @agent.post url_unfollow, @params, @request_headers
    rescue Mechanize::ResponseCodeError
      return false
    end
    response_data = JSON.parse(response.body)
    response.code == '200' && response_data['status'] == 'ok' ? true : false
  end

  # Likes the media if it doesn't exist in the database.
  #
  # @param media [MediaData] a MediaData instance.
  # @return (see #like_media)
  def like_if_not_in_db(media)
    return false if media.exists_in_db?(@table_likes)

    if like_media(media.id)
      @total_likes += 1
      print_success_message(action: :like, number: @total_likes, data: @media.id)
      media.insert_into_db(@table_likes)
      sleep_rand(28, 36)
      true
    else
      false
    end
  end

  # Follows the user if it doesn't exist in the database.
  #
  # @param user [UserData] a UserData instance.
  # @return (see #like_media)
  def follow_if_not_in_db(user)
    return false if user.exists_in_db?(@table_follows)

    if follow_user(user.id)
      @total_follows += 1
      print_success_message(action: :follow, number: @total_follows, data: @user.username)
      user.insert_into_db(@table_follows)
      sleep_rand(28, 36)
      true
    else
      false
    end
  end
end