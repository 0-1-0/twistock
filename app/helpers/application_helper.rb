module ApplicationHelper
  def with_sign(int)
    return int unless int.is_a? Fixnum
    return "+#{int}" if int >= 0
    int
  end

  def maybe_calculating(user, method_name)
    if user.share_price
      user.send(method_name)
    else
      if user.is_protected?
        t('status.share_price.unavailable')
      else
        t('status.share_price.calculating')
      end
    end
  end
end
