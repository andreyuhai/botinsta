# Contains methods for getting pages, query_id and JS link.
# To like a media from every tag we first need its query_id (a.k.a) query_hash
#
module Pages
  # Sets the query id for the current tag.
  #
  # @param tag [String] Current tag.
  # @return @query_id [String] Returns the instance variable @query_id
  def set_query_id(tag)
    response = @agent.get get_js_link tag
    # RegExp for getting the right query id. Because there are a few of them.
    match_data = /byTagName\.get\(t\)\.pagination},queryId:"(?<queryId>[0-9a-z]+)/.match(response.body)
    @query_id = match_data[:queryId]
  end

  # Returns the .js link of the TagPageContainer
  #   from which we will extract the query_id.
  # @param (see #set_query_id)
  # @return [String] Full link of the TagPageContainer.js
  def get_js_link(tag)
    response = @agent.get "https://instagram.com/explore/tags/#{tag}"
    # Parsing the returned page to select the script which has 'TagPageContainer.js' in its src
    parsed_page = Nokogiri::HTML(response.body)
    script_array = parsed_page.css('script').select {|script| script.to_s.include?('TagPageContainer.js')}
    script = script_array.first

    'https://instagram.com' + script['src']
  end

  # Gets first page JSON string for the tag to extract data
  #   (i.e. media IDs and owner IDs) and creates a PageData
  #   instance.
  #
  # @param (see #set_query_id)
  def get_first_page_data(tag)
    print_time_stamp
    puts 'Getting the first page for the tag '.colorize(:blue) + "##{tag}"
    response = @agent.get "https://www.instagram.com/explore/tags/#{tag}/?__a=1"
    data = JSON.parse(response.body.sub(/graphql/, 'data'))
    data.extend Hashie::Extensions::DeepFind
    @page = PageData.new(data)
  end

  # Gets next page JSON string for when we liked all the media
  #   on the first page and creates a PageData instance.
  #   This is where we need query_id and
  #   end_cursor string of the current page.
  #
  # @param (see #set_query_id)
  def get_next_page_data(tag)
    print_time_stamp
    puts 'Getting the next page for the tag '.colorize(:red) + "#{tag}"
    next_page_link =  "https://www.instagram.com/graphql/query/?query_hash=#{@query_id}&"\
                      "variables={\"tag_name\":\"#{tag}\"," \
                      "\"first\":10,\"after\":\"#{@page.end_cursor}\"}"
    response = @agent.get next_page_link
    data = JSON.parse(response.body)
    data.extend Hashie::Extensions::DeepFind
    @page = PageData.new(data)
  end

  # Gets user page JSON string and parses it
  #   to create a UserData instance.
  #
  # @param use_id [String] User id of the media owner.
  def get_user_page_data(user_id)
    url_user_detail = "https://i.instagram.com/api/v1/users/#{user_id}/info/"
    begin
    response = @agent.get url_user_detail
    rescue Mechanize::ResponseCodeError
      return false
    end
    data = JSON.parse(response.body)
    data.extend Hashie::Extensions::DeepFind
    @user = UserData.new(data)
    true
  end
end