class UserPolicy < ApplicationPolicy
  def get_referral_token?
    user.coach?
  end

  def create_exercise?
    user.coach?
  end

  def see_coach_exercises?
    user.coach?
  end
end
