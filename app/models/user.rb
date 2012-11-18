# encoding: utf-8
class User < ActiveRecord::Base
  # RELATIONS
  has_many :portfel,    class_name: BlockOfShares, foreign_key: :holder_id
  has_many :my_shares,  class_name: BlockOfShares, foreign_key: :owner_id

  has_many :history,    class_name: Transaction, foreign_key: :owner_id
  has_many :transactions
  has_one  :best_tweet

  has_many :product_invoices
  has_many :price_logs

  has_one :best_tweet

  # ACCESSORS
  # TODO: temporary access to all

  # VALIDATIONS
  validates :name, :nickname, :twitter_id, :avatar,
            presence: true
  validates :twitter_id, uniqueness: true

  # SCOPES
  scope :random,        ->(size) { order('RANDOM()').limit(size) }
  scope :highest_value, ->(size) { where{share_price != nil}.order{share_price.desc}.limit(size) }

  # INCLUDE MODULES (/lib/extras)
  include UserLogic::Trading
  include UserLogic::Pricing

  # CLASS METHODS
  class << self
    def find_by_nickname(nickname)
      User.where("upper(nickname) = upper('#{nickname}')").first
    end

    # По заданному списку ников выдает массив пользователей.
    # Если пользователя нет в базе - пытается его завести.
    # Регистронезависим. Имеет следующие опции:
    #
    # limit: int - выдать только указанное число пользователй
    # shuffle: bool - случайный порядок
    # history: bool - подгрузить history (includes)
    def find_by_nicknames(nicknames, opts = {})
      nicknames.map!(&:upcase)

      # создаем несуществующих
      exists = User.where{upper(nickname).in nicknames}.select(:nickname)
        .map(&:nickname).map(&:upcase)
      (nicknames - exists).each do |nick|
        User.find_or_create nick
      end

      # сама выборка
      result = User.where{upper(nickname).in nicknames}
      result = result.includes(:history)  if opts[:history]
      result = result.order('RANDOM()')   if opts[:shuffle]
      result = result.limit(opts[:limit]) if opts[:limit]
      result
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
      user =  User.find_by_twitter_id(auth.uid.to_i) or
              User.create( twitter_id:  auth.uid.to_i,
                           name:        auth.info.name,
                           nickname:    auth.info.nickname,
                           avatar:      auth.info.image,
                           money:       Settings.start_money
      )

      unless user.token
        FollowWorker.perform_async(user.id)
      end

      user.token  = auth.credentials.token
      user.secret = auth.credentials.secret
      user.save

      user.update_profile!
      user
    end

    def create_from_twitter_nickname(nickname)
      begin
        info = Twitter.user(nickname)
      rescue
        return nil
      end
      user = User.create(  twitter_id:  info.id,
                           name:        info.name,
                           nickname:    info.screen_name,
                           avatar:      info.profile_image_url,
                           money:       Settings.start_money
      )
      user.update_profile!
      user
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

  def profile_image
    avatar.sub("_normal", "")
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
  def popularity
    Rails.cache.fetch "user_#{id}_popularity", expires_in: 1.hour do
      my_shares.count
    end
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
end