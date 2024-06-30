class UserPolicy < ApplicationPolicy
  def get_referral_token?
    coach_permissions?
  end

  def create_exercise?
    coach_permissions?
  end

  def see_coach_exercises?
    coach_permissions?
  end

  def see_coach_clients?
    coach_permissions?
  end

  # TODO: implement see_coach_client? policy. Check if the client belongs to the coach

  private

  def coach_permissions?
    user.coach?
  end
end
