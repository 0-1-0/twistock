class AddPreviousPriceAndDeltaToPriceStamp < ActiveRecord::Migration
  def change
    add_column :price_stamps, :previous_price, :integer

    add_column :price_stamps, :delta, :integer

  end
end
