module UserLogic
  module Flows
    module Global
      SPORTS_NAMES = %w{
        SHAQ
        Cristiano Ronaldo
        Adam Schefter
        Bill Simmons
        Chad Johnson
        Dwight Howard
        Alyssa Milano
        LAMAR ODOM
        Mark Sanchez
        Pete Carroll
        Warren Sapp
        Baron Davis
        Danica Patrick
        Shaun White
        bubba watson
        John Daly
        Shawne Merriman
        Kaka
        KFUCKINGP
        Charlie Villanueva
        CC Sabathia
        Ndamukong Suh
        NBA
        Los Angeles Lakers
        Amar'e Stoudemire
        John Calipari
        InsideHoops.com
        Orlando Magic
        Boston Celtics
        Chicago Bulls
        NBA New York Knicks
        Jozy Altidore
        EA SPORTS
        FIFA.com
        New York Jets
        FOX Sports: MLB
        Jason Terry
        USA Basketball
        Bonnie Bernstein
        C.J. Wilson
        Jay Crawford
        MLB Public Relations
        Merril Hoge
        US Olympic Team
        Wimbledon
        Ricky Rubio
        Liverpool FC
        San Francisco Giants
        Will Kinsler
        Pau Gasol
        Chicago Blackhawks
        Lewis Howes
        Champ Bailey
        Maurice Edu
        New York Rangers
        Dhani Jones
        Los Angeles Clippers
        Atlanta_Falcons
        OKC THUNDER
        OAKLAND RAIDERS
        Minnesota Vikings
        Urijah Faber
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