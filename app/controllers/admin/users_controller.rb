# encoding: utf-8
class Admin::UsersController < Admin::BaseController
  before_filter :require_super_admin, only: [:staff_list]

  def search
    @mobile_log = Log::ContactPhone.find_or_initialize_by(mobile: params[:mobile])

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def contacted
    # TODO: Add logic for contacted users 已联系用户
    conds = {_type: 0, is_register: false}
    conds[:sender_id] = current_staff.id if staff?
    @mobiles = Log::ContactPhone.where(conds).order('updated_at desc').page(params[:page]||1).per(30)
  end

  def registered
    # TODO: Add logic for registered users 已注册用户
    @users = current_staff.customers.order('created_at desc').page(params[:page]||1).per(30)
  end

  def new
    user_hash = if params[:mask] == 'Staff'
                  {
                    mask: 'Staff',
                    contact: {
                      wx:              nil,
                      qq:              nil,
                      remark:          nil,
                      company_address: nil,
                      phone:           nil,
                      web_site:        nil,
                      company_email:   nil
                    }
                  }
                else
                  params.require(:user).permit!
                  params[:user].merge(
                    contact:  {
                                company_address:    nil,
                                position_header:    nil,
                                wx:                 nil,
                                qq:                 nil,
                                self_introduction:  nil
                  })
                end
    @user = User.new(user_hash)
  end

  def create
    if params[:staff]
      params.require(:staff).permit!
      @user = User.new(params[:staff])
    else
      params.require(:user).permit!
      @user = User.new(params[:user])
    end

    if @user.save
      if @user.mask.nil?
        log = Log::ContactPhone.where(mobile: @user.mobile).first_or_initialize
        log.is_register = true
        log._type = 0
        log.reg_admin = @current_staff
        log.save
        redirect_to registered_admin_users_path
      else
        redirect_to staff_list_admin_users_path
      end
    else
      redirect_to :new, @user
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    if @user.blank?
      redirect_to :back, notice: '很抱歉，此用户不存在'
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.mask.nil?
      params.require(:user).permit!
      @user.update_attributes(params[:user])

      redirect_to registered_admin_users_path
    else
      params.require(:staff).permit!
      @user.update_attributes(params[:staff])

      redirect_to staff_list_admin_users_path
    end
  end

  # 我来联系, 归入自己的通讯录
  def contact
    @contact_phone = Log::ContactPhone.new(
                mobile: params[:mobile],
                sender_id: current_staff.id
              )
    if @contact_phone.save
      redirect_to contacted_admin_users_path, notice: '已加入通讯录'
    else
      flash[:alert] = @contact_phone.errors.full_messages.join(', ')
      redirect_to search_admin_users_path(mobile: params[:mobile])
    end
  end

  # 指定业务员
  def set_staff
    @contact_phone = Log::ContactPhone.new(
                mobile: params[:mobile],
                sender_id: params[:staff_id]
              )
    if @contact_phone.save
      redirect_to contacted_admin_users_path, notice: '已加入通讯录'
    else
      flash[:alert] = @contact_phone.errors.full_messages.join(', ')
      redirect_to search_admin_users_path(mobile: params[:mobile])
    end
  end

  def index
    @users = User.normals.includes(:customer_service).order(created_at: :desc).page(params[:page]||1).per(30)
  end

  def staff_list
    @staffs = Staff.order(created_at: :desc).page(params[:page]||1).per(30)
  end

  def edit_staff
    @user = User.find_by_id(params[:id])
  end

  def update_staff
    @user = User.find_by_id(params[:id])

    params.require(:user).permit!

    @user.update_attributes(params[:user])

    redirect_to staff_list_admin_users_path
  end

  def update_remark
    @mobile = Log::ContactPhone.find_by_id(params[:id])
    @mobile.remark = params[:remark]
    @mobile.save

    redirect_to :back
  end

end
