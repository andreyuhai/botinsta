# Class handling media data.
# Takes a data object extended Hashie::Extensions::DeepFind
class MediaData

  attr_reader :id, :owner, :text, :shortcode, :tags

  def initialize(data)

    @id                 = data.deep_find('id')
    @owner              = data.deep_find('owner')['id']
    @is_video           = data.deep_find('is_video')
    @comments_disabled  = data.deep_find('comments_disabled')
    @text               = data.deep_find('text')
    @tags               = @text.nil? ? [] : @text.scan(/#[a-zA-Z0-9]+/)
    @shortcode          = data.deep_find('shortcode')

  end

  def comments_disabled?
    @comments_disabled
  end

  def blacklisted_tag?(tag_blacklist)
    !(@tags & tag_blacklist).empty?
  end

  def video?
    @is_video
  end

  def insert_into_db(table)
    table.insert(media_id: @id, user_id: @owner, shortcode: @shortcode, like_time: Time.now)
  end

  def delete_from_db(table)
    table.where(media_id: @id).delete
  end

  def exists_in_db?(table)
    !table.where(media_id: @id).empty?
  end
end