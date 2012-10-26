describe User do
  let!(:user1) { FactoryGirl.create(:user_with_base_price_and_money) }
  let!(:user2) { FactoryGirl.create(:user_with_base_price_and_money) }

  context "#buy_shares" do
    it 'should really buy =)' do
      user1.buy_shares(user2, 10)
      user1.stocks_in_portfel(user2).should == 10
    end

    it 'should post to twitter if option is set to true' do
      TweetWorker.should_receive(:buy_message).once

      user1.tap{ |u| u.twitter_translation = true }.save
      user1.buy_shares(user2, 10)
    end

    it 'should not post to twitter if option is set to false' do
      TweetWorker.should_not_receive(:buy_message)

      user1.tap{ |u| u.twitter_translation = false }.save
      user1.buy_shares(user2, 10)
    end

    it 'should create transaction' do
      expect { user1.buy_shares(user2, 10) }.to change { Transaction.count }.by(1)
    end
  end

  context "#sell_shares" do
    before(:all) do
      user1.buy_shares(user2, 10)
    end

    it 'should really sell =)' do
      user1.sell_shares(user2, 5)
      user1.stocks_in_portfel(user2).should == 5
    end

    it 'should post to twitter if option is set to true' do
      TweetWorker.should_receive(:sell_message).once

      user1.tap{ |u| u.twitter_translation = true }.save
      user1.sell_shares(user2, 5)
    end

    it 'should not post to twitter if option is set to false' do
      TweetWorker.should_not_receive(:sell_message)

      user1.tap{ |u| u.twitter_translation = false }.save
      user1.sell_shares(user2, 5)
    end

    it 'should create transaction' do
      expect { user1.sell_shares(user2, 5) }.to change { Transaction.count }.by(1)
    end
  end
end