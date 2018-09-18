require 'colorize'
require 'hashie'
require 'json'
require 'mechanize'
require 'sequel'
require 'sqlite3'
require 'nokogiri'

require_relative 'botinsta/class_methods'

class Botinsta

  include ClassMethods

  DEFAULT_PARAMETERS = { tags:              %w[photography fotografia vsco],
                         tag_blacklist:     %w[nsfw hot sexy],
                         user_blacklist:    [],
                         likes_per_tag:     10,
                         unfollows_per_day: 200,
                         follows_per_tag:   50
  }.freeze

  def initialize(**params)

    params = DEFAULT_PARAMETERS.merge(params)

    @username           = params[:username]
    @password           = params[:password]
    @tags               = params[:tags]
    @tag_blacklist      = params[:tag_blacklist]
    @user_blacklist     = params[:user_blacklist]
    @likes_per_tag      = params[:likes_per_tag]
    @follows_per_tag    = params[:follows_per_tag]
    @unfollows_per_day  = params[:unfollows_per_day]

    @total_likes        = 0
    @total_follows      = 0
    @total_unfollows    = 0

    @agent = Mechanize.new

    handle_database_creation
    return if @table_follows.empty?

    @first_db_entry = @table_follows.first
    @last_follow_time = @table_follows.first[:follow_time]
  end

  def start
    login
    tag_based_mode
    logout
  end
end
