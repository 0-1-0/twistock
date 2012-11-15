class BlockOfShares < ActiveRecord::Base
  belongs_to :holder, class_name: User
  belongs_to :owner,  class_name: User

  attr_accessible :count, :holder_id, :owner_id

  def one_share_cost
    return I18n.t('status.share_price.unavaible') if owner.share_price == -1
    owner.share_price || I18n.t('status.share_price.calculating')
  end

  def total_cost
    if owner.share_price
      owner.share_price * self.count
    else
      I18n.t('status.share_price.calculating')
    end
  end
end
