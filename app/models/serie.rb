class Serie < ApplicationRecord
  belongs_to :routine_day
  belongs_to :exercise
end
