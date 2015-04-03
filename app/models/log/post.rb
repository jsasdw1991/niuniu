# encoding: utf-8

class Log::Post < ActiveRecord::Base
  # tag: 此日志中的存的是method_names: [:view, :tender, :post_completed, :tender_completed]
  #      当某用户提交完成他的寻车时，相对应某个报价的日志也会有tender更新成tender_completed
  # resoruces: view
  # needs: tender, post_completed, tender_completed

  belongs_to :user, class_name: 'User'
  # belongs_to :post, class_name: 'Post', foreign_key: :post_id

  scope :views, -> { where(method_name: 'view').order(updated_at: :desc) }

  scope :completeds, -> { where(method_name: /completed/) }

  scope :last_months, ->(num) { where("created_at > ? and created_at < ?", Time.now.ago(num.months), Time.now) }

end
