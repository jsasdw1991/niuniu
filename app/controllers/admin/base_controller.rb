# encoding: utf-8

class Admin::BaseController < ApplicationController

  before_action :require_staff
  layout 'admin'

  def current_staff
    # TODO: Fake current_staff, need add the real logic
    @current_staff ||= current_user
  end

  # TODO: add logic
  # Internal staff: sales, admin, super_admin
  def require_staff
    if current_staff.class != Staff
      flash[:notice] = '很抱歉，您没有权限'
      redirect_to root_path
    end
  end

  def require_admin
    if current_staff.role == 'admin'
      return
    else
      flash[:notice] = '很抱歉，您没有权限'
      redirect_to admin_root_path
    end
  end

  def require_super_admin
    if current_staff.role == 'super_admin'
      return
    else
      flash[:notice] = '很抱歉，您没有权限'
      redirect_to admin_root_path
    end
  end

  def require_ad
    if %(super_admin admin).include?(current_staff.role)
      return
    else
      flash[:notice] = '很抱歉，您没有权限'
      redirect_to admin_root_path
    end
  end

  # ROLES = %w(normal staff admin super_admin) # 普通用户 业务员 普管 超管
  helper_method :staff?
  def staff?
    @current_staff.role == 'staff'
  end

  helper_method :admin?
  def admin?
    @current_staff.role == 'admin'
  end

  helper_method :super_admin?
  def super_admin?
    @current_staff.role == 'super_admin'
  end

end
