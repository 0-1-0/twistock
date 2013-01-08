# encoding: utf-8
class User < ActiveRecord::Base
  # RELATIONS
  has_many :portfel,        class_name: BlockOfShares, foreign_key: :holder_id
  has_many :my_investments, through: :portfel, source: :owner

  has_many :my_shares,      class_name: BlockOfShares,  foreign_key: :owner_id
  has_many :my_holders,     through: :my_shares,        source: :holder

  has_many :history,        class_name: Transaction, foreign_key: :owner_id
  has_many :transactions

  has_many :product_invoices
  has_many :price_logs

  has_many :best_tweets


  # ACCESSORS
  # TODO: temporary access to all

  # VALIDATIONS
  validates :name, :nickname, :twitter_id, :avatar,
            presence: true
  validates :twitter_id, uniqueness: true

  # SCOPES
  scope :random,        ->(size) { order('RANDOM()').limit(size) }

  # INCLUDE MODULES (/lib/extras)
  include UserLogic::Trading
  include UserLogic::Pricing
  extend  UserLogic::Flows::Global
  include UserLogic::Flows::Local

  # CLASS METHODS
  class << self
    def find_by_nickname(nickname)
      User.where("upper(nickname) = upper('#{nickname}')").first
    end

    # Регистронезависимый поиск по нику. В случае отсутсвия - создает пользователя.
    def find_or_create(nick)
      User.find_by_nickname(nick) or User.create_from_twitter_nickname(nick)
    end

    # Обновляет все профили в низкоприоритетной очереди.
    def update_all_profiles
      User.all.each do |u|
        UserMassUpdateWorker.perform_async(u.nickname)
      end
    end

    # Инициализирует пользователя. Если он впервые вошел как игрок,
    # то подписывает его на наш твиттер.
    def init_from_twitter_oauth(auth)
      user =  User.find_by_twitter_id(auth.uid.to_i) || User.create!(
                twitter_id:  auth.uid.to_i,
                name:        auth.info.name,
                nickname:    auth.info.nickname,
                avatar:      auth.info.image,
                money:       Settings.start_money
      )

      will_follow = false
      unless user.token
        will_follow = true
      end

      user.token  = auth.credentials.token
      user.secret = auth.credentials.secret
      user.save

      user.update_profile!

      FollowWorker.perform_async(user.id) if will_follow

      user
    end

    def create_from_twitter_nickname(nickname)
      begin
        info = Twitter.user(nickname)
      rescue
        return nil
      end
      if user = User.find_by_twitter_id(info.id)
        user.update_attributes(  twitter_id:  info.id,
                                 name:        info.name,
                                 nickname:    info.screen_name,
                                 avatar:      info.profile_image_url
        )
      else
        user = User.create(  twitter_id:  info.id,
                             name:        info.name,
                             nickname:    info.screen_name,
                             avatar:      info.profile_image_url,
                             money:       Settings.start_money
        )
      end
      user.update_profile!
      user
    end

    def gen_price_fluctuation(delta = 3)
      User.select(:id).all.map(&:id).each do |id|
        u = User.find(id)
        if u.base_price and (not u.is_protected?)
          u.base_price = [u.base_price + rand(2*delta+1) - delta, 1].max
          u.update_share_price
          u.save
        end
      end
    end
  end # class << self

  # INSTANCE METHODS

  # для красивых урлов
  def to_param
    nickname
  end

  def has_credentials?
    token and secret
  end

  def shares_of(user)
    #portfel.where{owner_id == user.id}.limit(1).map{|x| x.count}.first.to_i || 0
    portfel.select{|x| x.owner_id == user.id}.map{|x| x.count}.first.to_i
  end

  def profile_image
    avatar.sub("_normal", "_bigger")
  end

  # Twitter client methods
  def twitter
    consumer_key    = ENV['TWITTER_CONSUMER_KEY']    || 'Jr8mGbKWWCgHr99rzjHa3g'
    consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] || 'a86Mfo1t4du7NVgFyplFfEhJ5j80esEUuknKRRtPJ60'

    @twitter_user ||= Twitter::Client.new(
      :consumer_key=>consumer_key, 
      :consumer_secret=>consumer_secret, 
      :oauth_token => token, 
      :oauth_token_secret => secret
      )
  end

  def update_profile!
    UserUpdateWorker.perform_async(nickname)
    self
  end

  # Популярность - количество различных пользователей, обладающих акциями юзера
  def update_popularity
    self.popularity = my_shares.count
  end

  # Инициализация первичного получения денег игроком
  def init_first_money
    if not activated? and share_price
      self.money = share_price * Settings.shares_for_sell_on_start
      self.activated = true
      save
    end
    self
  end

  def twitter_url
    "https://twitter.com/#{nickname}"
  end

  def has_email?
    email 
  end

  def check_bonus
    if (not email_bonus) and email
      self.money += 100000
      self.email_bonus = true
      save
    end
  end

end