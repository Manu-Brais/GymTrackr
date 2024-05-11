class Client < ApplicationRecord
  validates :name, presence: true

  has_one :user, as: :authenticatable, dependent: :destroy
end
