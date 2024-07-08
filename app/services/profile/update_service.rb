# frozen_string_literal: true

module Profile
  class UpdateService < DryService
    def initialize(user_id:, user_data:)
      @user_id = user_id
      @user_data = user_data
    end

    def call
      user = yield get_user
      user = yield attach_picture(user)
      update_data(user)
    end

    private

    def get_user
      Try[ActiveRecord::RecordNotFound] do
        User.find(@user_id).authenticatable
      end.to_result
    end

    def attach_picture(user)
      return Success(user) unless @user_data[:picture]

      user.avatar.attach(@user_data[:picture].to_io)
      Success(user)
    end

    def update_data(user)
      return Failure(user.errors.full_messages.to_sentence) unless user.update(@user_data.except(:picture))

      Success(user)
    end
  end
end
