# frozen_string_literal: true

module Profile
  class UpdateService < DryService
    def initialize(user_id:, user_data:)
      @user_id = user_id
      @user_data = user_data
    end

    def call
      user = yield get_user
      update_data(user)
    end

    private

    def get_user
      Try[ActiveRecord::RecordNotFound] do
        User.find(@user_id).authenticatable
      end.to_result
    end

    def update_data(user)
      return Failure(user.errors.full_messages.to_sentence) unless user.update(@user_data)

      Success(user)
    end
  end
end
