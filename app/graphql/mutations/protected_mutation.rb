# frozen_string_literal: true

module Mutations
  class ProtectedMutation < BaseMutation
    include Helpers::Authorization

    def ready?(**_args)
      authenticate_user!
      true
    end
  end
end
