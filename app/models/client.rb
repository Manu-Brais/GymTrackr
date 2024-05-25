class Client < ApplicationRecord
  has_one :user, as: :authenticatable, dependent: :destroy
  belongs_to :coach
end
