# encoding: utf-8

# author: depp.yu

class BaseCar < ActiveRecord::Base

  STATUS = {
    0 => '激活',
    1 => '未激活'
  }

  belongs_to :standard, class_name: 'Standard' # 属于那种规格
  belongs_to :brand, class_name: 'Brand' # 属于那种车辆品牌
  has_many   :car_photos, as: :owner, dependent: :nullify, autosave: true # 图片数据


  # instance_methods
  def to_human_name
    self.brand.name << self.model << self.NO
  end

  def to_hash
    {
      id:             id,
      resource_name:  'BaseCar',
      model:          model,
      style:          style,
      number:         self.NO,
      outer_color:    outer_color,
      inner_color:    inner_color,
      base_price:     base_price.to_f
    }
  end

end
