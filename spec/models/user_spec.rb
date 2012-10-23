# encoding: utf-8
require 'spec_helper'

describe User do

  # trivial checks: validations and relations
  context "model" do
    %w(uid name nickname avatar).each do |attr|
      it {should validate_presence_of(attr)}
    end

    [
        [:portfel, BlockOfShares],
        [:my_shares, BlockOfShares],
        [:history, Transaction],
        [:transactions],
        [:product_invoices]
    ].each do |x|
      it {should have_many(x[0]).class_name(x[1])}
    end
  end

  context ".find_by_nickname" do
    let!(:user) { FactoryGirl.create(:user, nickname: 'TestNick') }

    it 'should find by exact nickname' do
      User.find_by_nickname('TestNick').should eq(user)
    end

    it 'should be case insensitive' do
      User.find_by_nickname('TestNick').should eq(user)
    end
  end

  context ".find_by_nicknames" do
    nicknames = %w(one two three)
    nicknames.each do |nick|
      let!("user_#{nick}") { FactoryGirl.create(:user, nickname: nick) }
    end

    let!(:created_from_twitter) { FactoryGirl.build(:user, nickname: 'from_twitter') }

    it 'should find by exact nicknames and save order' do
      User.find_by_nicknames(nicknames).should eq([user_one, user_two, user_three])
    end

    it 'should be case insensitive' do
      User.find_by_nicknames(%w(ONE)).should eq([user_one])
    end

    it 'should work fine with limit' do
      User.find_by_nicknames(nicknames, limit: 2).should eq([user_one, user_two])
    end

    it 'should create from twitter when no user exists' do
      User.should_receive(:create_from_twitter_nickname).once.with('FROM_TWITTER')
        .and_return { created_from_twitter.tap {|u| u.save} }
      User.find_by_nicknames(%w(from_twitter)).should eq([created_from_twitter])
    end

    # xit 'should includes history when history option is set' # no idea how test it
    # xit 'should return with random order when random option is set' # no idea how test it
  end

  context ".find_or_create" do
    let!(:user) { FactoryGirl.create(:user, nickname: 'user') }
    let!(:user_b) { FactoryGirl.build(:user, nickname: 'user_b') }

    it 'should find by exact name' do
      User.find_or_create('user').should == user
    end

    it 'should find by uppercased name' do
      User.find_or_create('USER').should == user
    end

    it 'should create when no exists' do
      User.should_receive(:create_from_twitter_nickname).once.with('user_b')
        .and_return { user_b.tap {|u| u.save} }
      User.find_or_create('user_b').should == user_b
    end
  end

  context ".update_all_profiles" do
    nicknames = %w(one two three)
    nicknames.each do |nick|
      let!("user_#{nick}") { FactoryGirl.create(:user, nickname: nick) }
    end

    it 'should affect all users' do
      nicknames.each do |nick|
        UserMassUpdateWorker.should_receive(:perform_async).once.with(nick)
      end
      User.update_all_profiles
    end
  end

  context ".create_from_twitter_oauth" do
    pending
  end

  context ".create_from_twitter_nickname" do
    it 'should correct create existing user (case insensitive)' do
      user = User.create_from_twitter_nickname('mr_fFloyd')
      user.name.should == 'Kolesnev Roman'
      user.nickname.should == 'mr_ffloyd'
      user.uid.should == 24669295
    end

    it 'should return nil if no user' do
      User.create_from_twitter_nickname('safgfahaffaahdfhafafd').should be_nil
    end
  end

  context focus: true do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user_without_creds) { FactoryGirl.create(:user_without_creds) }
    subject { user }

    context '#to_param' do
      its(:to_param) { should == user.nickname }
    end

    context "#has_credentials?" do
      its(:has_credentials?) { should be_true }
      it 'should be false if creds not exist' do
        user_without_creds.has_credentials?.should be_false
      end
    end

    context "#follow_twistock" do
      # TODO: почему-то здесь все же вызывается perform_async... Надо у пацанов в IRC спросить, что за хуйня
      it 'should not work without credentials' do
        FollowWorker.should_not_receive(:perform_async)
        user_without_creds.follow_twistock
      end

      it 'should work with credentials' do
        FollowWorker.should_receive(:perform_async).once
          .with(user.id).and_return(true)
        user.follow_twistock
      end
    end

    context "#stocks_in_portfel" do
      let!(:another_user) { FactoryGirl.create(:user) }

      let!(:bos1) { FactoryGirl.create(:block_of_shares, holder: user) }
      let!(:bos2) { FactoryGirl.create(:block_of_shares, holder: user, owner: another_user) }

      it {user.stocks_in_portfel(another_user).should == bos2.count}
    end

    context '#profile_image' do
      its(:profile_image) { should == user.avatar.sub("_normal", "") }
    end

    context '#update_oauth_info_if_necessary' do
      let(:auth) do
        double  :auth,
                credentials: double(:credentials, token: 'token', secret: 'secret')
      end

      it 'should not update if token and secret exist' do
        expect {user.update_oauth_info_if_necessary(auth)}
          .to_not change {user.token + user.secret}
      end

      it 'should update if no secret or token' do
        expect {user_without_creds.update_oauth_info_if_necessary(auth)}
          .to change {user_without_creds.token and user_without_creds.secret}
      end
    end
  end
end
