class RoutineDay < ApplicationRecord
  belongs_to :routine
  has_many :series, dependent: :destroy, class_name: 'Serie'
end
