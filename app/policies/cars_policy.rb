class CarsPolicy
  def initialize(user, model, *)
    @user = user
    @model = model
  end

  def can_work_with_car?
    @user.role.in?(%w[Admin Manager])
  end

  def can_show_car?
    if @user.manager? && @user.affiliate_id == @model.affiliate_id
      return true
    elsif @user.manager? && @user.affiliate_id != @model.affiliate_id
      return false
    end
    @user.admin?
  end

  def can_delete_car?
    if @user.manager? && @user.affiliate_id == @model.affiliate_id
      return true
    elsif @user.manager? && @user.affiliate_id != @model.affiliate_id
      return false
    end
    @user.admin?
  end
end
