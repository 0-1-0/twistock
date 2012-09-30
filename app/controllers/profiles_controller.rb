class ProfilesController < ApplicationController
  def show
    @user = User.find_or_create(params[:id])

    return redirect_to(not_found_path) unless @user

    #'sell' starting stocks
    if @user.has_starting_stocks
      @user.sell_starting_stocks # TODO: may be duplicate
    end

    @my_page  = (@user == current_user)

    #Определяем популярность пользователя
    @popularity = Transaction.where(:owner_id=>@user.id).where("created_at >= :time", {:time => Time.now - 42000}).count

    respond_to do |format|
      format.html
      format.json{
        render :json => @user.to_json
      }
    end
  end



  def price_after_transaction
    @answer = 0

    user = User.find_or_create(params[:id])
    count = params[:count].to_i

    if user and count
      @answer = user.price_after_transaction(count).round
    end

    respond_to do |format|
      format.json{
        render :json => @answer
      }
    end
  end


  def search
    redirect_to profile_path(params[:nickname])
  end

  def change_language
    if (params[:locale] == 'ru' or params[:locale] == 'en') and current_user
      current_user.locale = params[:locale]
      current_user.save
    end

    redirect_to :back
  end


end
