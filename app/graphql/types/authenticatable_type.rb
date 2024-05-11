module Types
  class AuthenticatableType < BaseUnion
    possible_types Types::CoachType, Types::ClientType

    def self.resolve_type(object, context)
      case object
      when ::Coach
        Types::CoachType
      when ::Client
        Types::ClientType
      else
        raise Errors::SignUpError.new("Unknown type for Authenticatable: #{object}")
      end
    end
  end
end
