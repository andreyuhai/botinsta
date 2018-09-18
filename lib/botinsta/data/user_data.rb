# Class handling user data.
# Takes a data object extended Hashie::Extensions::DeepFind
class UserData

  attr_reader :id, :username, :full_name, :follower_count, :following_count

  def initialize(data)
    @id              = data.deep_find('pk')
    @username        = data.deep_find('username')
    @full_name       = data.deep_find('full_name')
    @following_count = data.deep_find('following_count')
    @follower_count  = data.deep_find('follower_count')
    @is_private      = data.deep_find('is_private')
  end

  def private?
    @is_private
  end

  def insert_into_db(table)
    table.insert(user_id: @id, username: @username, follow_time: Time.now)
  end

  def delete_from_db(table)
    table.where(user_id: @id).delete
  end

  def exists_in_db?(table)
    !table.where(user_id: @id).empty?
  end
end