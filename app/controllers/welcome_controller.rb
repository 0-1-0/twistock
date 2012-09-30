# encoding: utf-8
class WelcomeController < ApplicationController

      # TODO: вытащить в YAML config + initilizer
      # TODO: По хорошему вытащить в базу и агрессивно кэшировать,
      #       но это с приходом нормальной адмики
      #       где можно будет этот список редактировать.
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
    @celebrities    = User.find_by_nicknames(CELEBRITIES_NAMES, shuffle: true, limit: MAX_USERS_PER_PAGE)
    @politicians    = User.find_by_nicknames(POLITICIANS_NAMES, shuffle: true, limit: MAX_USERS_PER_PAGE)                      
    @random         = User.random(MAX_USERS_PER_PAGE)
    @highest_value  = User.highest_value(MAX_USERS_PER_PAGE)

    current_user.sell_user_retention_shares if signed_in? 
  end

  def not_found
  end

  def thanks
  end

  def mobile
    render :layout=>false
  end
end
