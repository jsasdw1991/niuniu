# encoding: utf-8
# author: depp.yu
require 'pty'

namespace :init_data do

  desc "init database and run migrations"
  task database: :environment do
    cmds = ['rake db:drop', 'rake db:create', 'rake db:migrate']

    cmds.each do |_cmd|
      begin
        PTY.spawn( _cmd ) do |r, w, pid|
          begin
            r.each {|line| print line; }
          rescue Errno::EIO
          end
        end
      rescue Exception => e
        puts 'some wrong happen' + e.message
        next
      end
    end

  end

  task users: :environment do
    # Users
    ha = {
      name:     'test',
      mobile:   '15802162343',
      role:     User::ROLES[0],
      level:    User::LEVELS.keys[0],
      status:   User::STATUS.keys[1],
      password: '123456',
      company: 'test',
      area: Area.last
    }
    user = User.create(ha) unless User.find_by_mobile(ha[:mobile])

    ha_1 = {
      name:     'admin',
      mobile:   '15802162344',
      role:     User::ROLES[1],
      level:    User::LEVELS.keys[0],
      status:   User::STATUS.keys[1],
      password: '123456',
      company: 'test',
      area: Area.last
    }

    admin = User.create(ha_1) unless User.find_by_mobile(ha_1[:mobile])
  end

  task posts: :environment do
    user     = User.first
    standard = Standard.first
    brand    = standard.brands.first
    base_car = brand.base_cars.first
    post     = Post.new(
                 _type:             [0, 1].sample,
                 standard_id:       standard.id,
                 brand_id:          brand.id,
                 user_id:           user.id,
                 model:             base_car.model,
                 outer_color:       base_car.outer_color.sample,
                 inner_color:       base_car.inner_color.sample,
                 car_license_areas: Area.first.name,
                 car_in_areas:      brand.regions.sample(2),
                 style:             base_car.style,
                 discount_way:      1,
                 discount_content:  0.9
               )
    post.base_car = base_car
    post.save
  end

end
