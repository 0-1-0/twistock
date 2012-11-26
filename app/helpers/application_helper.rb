module ApplicationHelper
  def with_sign(int)
    return int unless int.is_a? Fixnum

    if int >= 0
      "<span class=\"green\">+#{int}</span>".html_safe
    else
      "<span class=\"red\">#{int}</span>".html_safe
    end
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

  def active_when(condition)
    condition ? 'active ' : ''
  end
end
