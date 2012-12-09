module UserLogic
  module Flows
    module Global
      SPORTS_NAMES = %w{
        NickSwisher
        sashin_rt
        Carles5puyol
        cesc4official
        paulpierce34
        FloydMayweather
        DwayneWade
        andresiniesta8
        DiegoForlan7
        RyanScheckler
        reggie_bush
        RealLamarOdom
        WayneRooney
        serenawilliams
        DwightHoward
        Ronaldinho
        ClaroRonaldo
        tonyhawk
        Njr92
        KingJames
        ochocinco
        SHAQ
        Cristiano
        KAKA
        JeffGordonWeb
        MagicJohnson 
        MikeTyson
        DjokerNole
        KDTrey5
        DwyaneWade
        MichaelPhelps
        TimTebow
        paugasol
        EmmittSmith22
        davidortiz 
        DwightHoward
        steveaustinBSR 
        andy_murray
        ryanlochte 
        JensonButton
        Pele
        LewisHamilton
        AussieGrit
        Venuseswilliams 
        andresiniesta8
      }

      # По заданному списку ников выдает массив пользователей.
      # Если пользователя нет в базе - пытается его завести.
      # Регистронезависим. Имеет следующие опции:
      #
      # limit: int - выдать только указанное число пользователй
      # shuffle: bool - случайный порядок
      # history: bool - подгрузить history (includes)
      def find_by_nicknames(nicknames, opts = {})
        nicknames.map!(&:upcase)

        # создаем несуществующих
        exists = User.where{upper(nickname).in nicknames}.select(:nickname)
        .map(&:nickname).map(&:upcase)
        (nicknames - exists).each do |nick|
          User.find_or_create nick
        end

        # сама выборка
        result = User.where{upper(nickname).in nicknames}
        result = result.includes(:history)  if opts[:history]
        result = result.order('RANDOM()')   if opts[:shuffle]
        result = result.limit(opts[:limit]) if opts[:limit]
        result
      end

      def find_by_twitter_ids(ids)
        exists = User.where{twitter_id.in ids}.select(:twitter_id).map(&:twitter_id)
        (ids - exists).each do |tid|
          User.create_from_twitter_nickname(tid)
        end

        User.where{twitter_id.in ids}
      end

      def most_expensive
        User.where{share_price != nil}.order{share_price.desc}
      end

      def top
        User.where{popularity != nil}.order{popularity.desc}
      end

      def sports
        User.find_by_nicknames SPORTS_NAMES, shuffle: true
      end
    end

    module Local
      #def my_investments
      #  portfel.includes(:owner).map {|x| x.owner}.uniq
      #end

      #def my_holders
      #  my_shares.includes(:holder).map {|x| x.holder}.uniq
      #end

      def friend_ids
        Rails.cache.fetch "user_#{id}_friend_ids", expires_in: 10.minutes do
          twitter.follower_ids.ids[0..100]
        end
      end

      def my_friends
        User.find_by_twitter_ids(friend_ids).where{share_price != nil}.order{share_price.desc}
      end
    end
  end
end