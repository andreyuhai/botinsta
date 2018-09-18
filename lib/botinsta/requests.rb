module Requests

  def set_request_params(params = {})

    @params = params
    set_cookies
    set_request_headers

  end

  # Sets cookies to use in requests
  def set_cookies

    @cookies = Hash[@agent.cookies.map {|key| [key.name, key.value]}]

  end

  # Sets headers to use in requests.
  def set_request_headers

    @request_headers = {

        'Cookie' => "mid=#{@cookies['mid']}; csrftoken=#{@cookies['csrftoken']}; "\
                            "sessionid=#{@cookies['sessionid']}; ds_user_id=#{@cookies['dsuserid']}; "\
                            "rur=#{@cookies['rur']}; s_network=#{@cookies['s_network']}; "\
                            "ig_pr=1; ig_vw=1920",
        'X-CSRFToken' => (@cookies['csrftoken']).to_s,
        'X-Requested-With' => 'XMLHttpRequest',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'X-Instagram-AJAX' => '1',
        'Accept' => 'application/json, text/javascript, */*',
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0',
        'Accept-Encoding' => 'gzip, deflate',
        'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
        'Connection' => 'keep-alive',
        'Host' => 'www.instagram.com',
        'Origin' => 'https://www.instagram.com',
        'Referer' => 'https://www.instagram.com'
    }

  end

end