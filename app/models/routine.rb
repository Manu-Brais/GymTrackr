class Routine < ApplicationRecord
  belongs_to :client
  has_many :routine_days, dependent: :destroy
end
