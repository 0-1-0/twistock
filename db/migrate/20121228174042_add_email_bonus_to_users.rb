class AddEmailBonusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_bonus, :boolean
  end
end
