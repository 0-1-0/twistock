window.with_sign = (int) ->
  return '' if typeof int == "undefined"
  return '' if int == null

  if int >= 0
    "<span class=\"green\">+#{int}</span>"
  else
    "<span class=\"red\">#{int}</span>"


window.maybe_calculating = (model, attr) ->
  if model.get('share_price')
    model.get(attr)
  else
    if model.get('is_protected')
      I18n.t('status.share_price.unavailable')
    else
      I18n.t('status.share_price.calculating')