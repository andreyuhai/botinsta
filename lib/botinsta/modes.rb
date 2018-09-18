# Contains bot functions.
module Modes

  def tag_based_mode

    # For each tag we should like as many images as our per tag limit.
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
        elsif like_count == @page.media_count && @page.has_next_page?
          get_next_page_data(tag)
        end
        @page.medias.each do |media|
          media.extend Hashie::Extensions::DeepFind
          @media = MediaData.new(media)
          next if @media.blacklisted_tag?(@tag_blacklist)

          get_user_page_data(@media.owner)

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
            if follow_if_not_in_db(@user)
              follow_count += 1
            else
              print_error_message(action: :follow, data: @user.username)
            end
          end

          break if like_count == @likes_per_tag && follow_count == @follows_per_tag
        end

        # Here is the code for unfollowing users
        if !@table_follows.empty? && one_day_past?(@last_follow_time) && @total_unfollows != @unfollows_per_day
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
      end
    end
  rescue Interrupt
    logout
  end
end