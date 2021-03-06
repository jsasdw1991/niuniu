# encoding: utf-8

# author: depp.yu

class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :user, class_name: 'User', null: false
      t.column :value, :string, limit: 50, null: false # token 值
      t.column :expired_at, :datetime # 过期日期
      t.column :status, :integer, default: 0
      t.timestamps null: false
    end

    add_index(:tokens, :user_id)
    add_index(:tokens, :value)
  end
end
