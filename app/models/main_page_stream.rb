class MainPageStream < ActiveRecord::Base
  attr_accessible :eng_name, :eng_tooltip, :list_of_users, :priority, :ru_name, :tu_tooltip

  def users
    ids = list_of_users.split("\r\n")

    final_list = []
    ids.each do |id|
      user = User.find_by_nickname(id)
      if user
        final_list += [user]
      end
    end

    return final_list
  end
end
