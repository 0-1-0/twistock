class WelcomeController < ApplicationController

      CELEBRITIES_NAMES = [ 
                          'SergeiMinaev',\
                          'shirokovr15',\
                          'M_Galustyan',\
                          'durov',\
                          'adagamov',\
                          'tina_kandelaki',\
                          'VRSoloviev',\
                          'mnzadornov',\
                          'EvgeniPlushenko',\
                          'Garik2000',\
                          'VS_Oblomov',\
                          'olegtinkov',\
                          'VictoriaDaineko',\
                          'dolboed',\
                          'TimatiOfficial',\
                          'SatiKazanova',\
                          'dolyasergey',\
                          'maksimofficial',\
                          'kichanova',\
                          'elkasinger'
      ]

      POLITICIANS_NAMES = [\
                        'MedvedevRussia',\
                        'xenia_sobchak',\
                        'KermlinRussia',\
                        'navalny',\
                        'rykov',\
                        'SurkovRussia',\
                        'alyonapopova',\
                        'hirinovskiy',\
                        'Khinshtein',\
                        'mironov_ru',\
                        'NikitaBelyh',\
                        'LeninRussia',\
                        'iponomarev',\
                        'G_Zyuganov',\
                        'Aleksei_Kudrin',\
                        'MD_Prokhorov',\
                        'szhurova',\
                        'medinskiy_vr',\
                        'advorkovich',\
                        'Shlegel',\
                        'gudkovd',\
                        '4irikova',\
                        'G_Poltavchenko'\
      ]

      MAX_USERS_PER_PAGE = 5                



  def index
    @celebrities = User.find_by_nicknames(CELEBRITIES_NAMES)
    @celebrities = @celebrities.shuffle
    @celebrities = @celebrities[0..MAX_USERS_PER_PAGE]

    @politicians = User.find_by_nicknames(POLITICIANS_NAMES)
    @politicians = @politicians.shuffle
    @politicians = @politicians[0..MAX_USERS_PER_PAGE]              




    #redirect_to profile_path(current_user) if signed_in?
    if signed_in?
      #'sell' starting shares
      if current_user.retention_shares > 0 and current_user.share_price
        current_user.sell_retention(current_user.retention_shares)
      end
    end
  end

  def not_found
  end

  def thanks
  end

  def mobile
    render :layout=>false
  end
end
