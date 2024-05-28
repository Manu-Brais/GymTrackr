class UserPolicy < ApplicationPolicy
  def get_referral_token?
    user.coach?
  end
end
