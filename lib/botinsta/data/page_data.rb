# Class handling media data.
# Takes a data object extended Hashie::Extensions::DeepFind
class PageData

  attr_reader :hashtag_id, :hashtag_name, :end_cursor,
              :medias, :media_count, :top_medias, :top_media_count,
              :all_media, :all_media_count

  def initialize(data)

    @hashtag_id       = data.deep_find('hashtag')['id']
    @hashtag_name     = data.deep_find('hashtag')['name']
    @has_next_page    = data.deep_find('page_info')['has_next_page']
    @end_cursor       = data.deep_find('end_cursor')
    @top_medias       = data['data']['hashtag']['edge_hashtag_to_top_posts']['edges']
    @top_media_count  = @top_medias.count
    @medias           = data['data']['hashtag']['edge_hashtag_to_media']['edges']
    @media_count      = @medias.count + @top_media_count
    @all_media        = @top_medias + @medias
    @all_media_count  = @all_media.count

  end

  def next_page?
    @has_next_page
  end

  def end_cursor_nil?
    @end_cursor.nil?
  end

  def medias_empty?
    @medias.empty?
  end

end