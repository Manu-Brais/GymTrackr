class Coach < ApplicationRecord
  # TODO - Add more validations, like phone number, address, etc.
  validates :name, presence: true

  has_one :user, as: :authenticatable, dependent: :destroy
end
