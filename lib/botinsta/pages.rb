# Functions for getting the pages, query id and js link
module Pages
  # We should set our query id for post requests (for follows, likes, etc.)
  def set_query_id(tag)
    response = @agent.get get_js_link tag
    # RegExp for getting the right query id. Because there are a few of them.
    match_data = /byTagName\.get\(t\)\.pagination},queryId:"(?<queryId>[0-9a-z]+)/.match(response.body)
    @query_id = match_data[:queryId]
  end

  # Returns the .js link of the TagPageContainer which has the query id in itself.
  def get_js_link(tag)
    response = @agent.get "https://instagram.com/explore/tags/#{tag}"
    # Parsing the returned page to select the script which has 'TagPageContainer.js' in its src
    parsed_page = Nokogiri::HTML(response.body)
    script_array = parsed_page.css('script').select {|script| script.to_s.include?('TagPageContainer.js')}
    script = script_array.first

    'https://instagram.com' + script['src']
  end

  # To get the JSON string for the first time. (with the link provided below)
  def get_first_page_data(tag)
    print_time_stamp
    puts 'Getting the first page for the tag '.colorize(:blue) + "##{tag}"
    response = @agent.get "https://www.instagram.com/explore/tags/#{tag}/?__a=1"
    data = JSON.parse(response.body.sub(/graphql/, 'data'))
    data.extend Hashie::Extensions::DeepFind
    @page = PageData.new(data)
  end

  # Gets the next pages using the query_id and end_cursor
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

  def get_user_page_data(user_id)
    url_user_detail = "https://i.instagram.com/api/v1/users/#{user_id}/info/"
    response = @agent.get url_user_detail
    data = JSON.parse(response.body)
    data.extend Hashie::Extensions::DeepFind
    @user = UserData.new(data)

  end
end