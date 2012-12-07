class PriceLog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :price, :user_id

  validates_presence_of :price, :user_id

  class << self
    def get_user_log(user, opts = {})
      query = PriceLog.where(user_id: user.id).order{created_at.asc}
      if opts[:from] and opts[:to]
        query = query.where{ (created_at >= opts[:from]) & (created_at <= opts[:to])}
      elsif opts[:for]
        query = query.where{ created_at >= Time.now - opts[:for] }
      end

      # Monkey patch
      if query.size <= 1
        return [[user.share_price, Time.now - 10],[user.share_price, Time.now]]
      end

      query = [query.first, query.last] if opts[:first_and_last]
      query.map {|x| [x.price, x.created_at] }
    end
  end
end
