class ProfilesController < ApplicationController
  before_filter :user_required

  def show
    unless @user = ( User.find_by_nickname(params[:id]) or User.create_from_twitter(params[:id]) )
      return redirect_to not_found_path
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

    #рисуем график цены
    
    @data = @user.history.collect(&:price)

    @lc = GoogleChart::LineChart.new("400x200", "Price History", false)
    @lc.data "price", @data, '7777dd'
   
    
  end

  def search
    redirect_to profile_path(params[:nickname])
  end


end
