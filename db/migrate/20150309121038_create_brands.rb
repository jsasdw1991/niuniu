# encoding: utf-8

# author: depp.yu
# 车辆品牌database mapper

class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.column :name, :string, limit: 40, null: false # 车辆名称
      t.references :standard,  class_name: 'Standard' # 与规格关联
      t.column :regions, :string, array: true #
      t.column :status, :integer
      t.timestamps null: false
    end
  end
end
