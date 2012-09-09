class ProfilesController < ApplicationController
  def show
    unless @user = ( User.find_by_nickname(params[:id]) or User.create_from_twitter(params[:id]) )
      return redirect_to not_found_path
    end

    #'sell' starting stocks
    if @user.has_starting_stocks
      @user.sell_starting_stocks
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
