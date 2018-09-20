# Contains bot modes.
# The bot has only one mode for now, which is tag based mode.
# In this mode bot works on a tag basis. Gets medias from specified tags,
#   likes them and follows the owner of the media until it fulfills
#   its like and follow limits for the day.
module Modes

  def tag_based_mode
    @tags.each do |tag|
      like_count = 0; follow_count = 0
      is_first_page = true
      print_tag_message tag
      until like_count == @likes_per_tag && follow_count == @follows_per_tag

        if is_first_page
          set_query_id(tag)
          get_first_page_data(tag)
          is_first_page = false
          break if @page.medias_empty?
        elsif @page.next_page?
          get_next_page_data(tag)
        end
        @page.medias.each do |media|
          media.extend Hashie::Extensions::DeepFind
          @media = MediaData.new(media)
          next if @media.blacklisted_tag?(@tag_blacklist)

          # Here is the code for liking stuff.
          if like_count != @likes_per_tag
            if like_if_not_in_db(@media)
              like_count += 1
            else
              print_error_message(action: :like, data: @media.id)
            end
          end

          # Here is the code for following users.
          if follow_count != @follows_per_tag
            if get_user_page_data(@media.owner) && follow_if_not_in_db(@user)
              follow_count += 1
              refresh_db_related if follow_count == 1
            else
              print_error_message(action: :follow, data: @user.username)
            end
          end

          # Here is the code for unfollowing users
          if !@table_follows.empty? && unfollow_threshold_past?(@last_follow_time) && @total_unfollows != @unfollows_per_run
            if unfollow_user(@first_db_entry[:user_id])
              @total_unfollows += 1
              print_success_message(action: :unfollow, number: @total_unfollows,
                                    data: @first_db_entry[:username])
              delete_from_db(@first_db_entry[:user_id])
              refresh_db_related
            else
              false
            end
          end
          break if like_count == @likes_per_tag && follow_count == @follows_per_tag
        end
      end
    end
  rescue Interrupt
    logout
    exit
  end
end