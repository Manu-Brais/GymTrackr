class Types::AuthenticatableType < Types::BaseUnion
  possible_types Types::CoachType, Types::ClientType

  def self.resolve_type(object, context)
    case object
    when Coach
      Types::CoachType
    when Student
      Types::ClientType
    else
      raise "Unknown type for Authenticatable: #{object}"
    end
  end
end
