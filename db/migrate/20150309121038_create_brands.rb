# encoding: utf-8

# author: depp.yu
# 车辆品牌database mapper

class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.column :name, :string, limit: 40, null: false # 车辆名称
      t.column :regions, :string, array: true #
      t.column :status, :integer, default: 0 # 1 激活 0 未激活
      t.column :click_counter, :integer, default: 0 # 点击次数

      t.timestamps null: false
    end

    add_index(:brands, :name)
  end
end
