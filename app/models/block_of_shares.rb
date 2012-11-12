class BlockOfShares < ActiveRecord::Base
  belongs_to :holder, class_name: User
  belongs_to :owner,  class_name: User

  attr_accessible :count, :holder_id, :owner_id

  # TODO: прикрутить i18n на оба метода
  def one_share_cost
    self.owner.share_price || 'calculating...'
  end

  def total_cost
    if self.owner.share_price
      self.owner.share_price * self.count
    else
      'calculating...'
    end
  end
end
