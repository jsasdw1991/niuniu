# encoding: utf-8

# author: depp.yu
# user模型的database mapper

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :name,   :string, limit: 15,  null: false # 用户名称
      t.column :mobile, :string, limit: 15, null: false # 用户手机号码 用于登陆
      t.column :_type,  :integer # 用户类型（原来该字段用户表示用户是4S用户，还是经销商用户，目前用level表示）
      t.column :company, :string, limit: 225 # 用户公司
      t.column :role, :string, limit: 30, default: 'normal'  # 用户角色
      t.column :reg_status, :integer, default: 0 # 注册状态 0 web 1 ios 2 android 3 background
      t.references :area, class_name: 'Area', null: false # 外键 -- 引用area类
      t.column :level, :integer, default: 0 # 用户等级 0 => 个人, 1 => 认证资源, 2 => 认证综展, 3 => 4S
      t.column :status, :integer, default: 0 # 新建状态, 1 后台审理通过 -1 已删除
      t.column :contact, :jsonb, default: {} # 联系方式 qq wx
      t.column :job_number, :string, limit: 15 # 公司人员工号
      t.references :customer_service, class_name: 'Staff'
      t.column :mask, :string, limit: 10 # 却别用户 继承关系
      t.timestamps null: false
    end

    add_index(:users, :name)
    add_index(:users, :area_id)
    add_index(:users, :level)
    add_index(:users, :job_number)
  end
end
