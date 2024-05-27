class CoachClient < ApplicationRecord
  belongs_to :coach
  belongs_to :client
end
