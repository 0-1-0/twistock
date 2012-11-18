module ApplicationHelper
  def with_sign(int)
    return "+#{int}" if int >= 0
    int
  end
end
