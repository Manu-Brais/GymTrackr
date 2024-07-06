# frozen_string_literal: true

module Types
  class PageInfoType < Types::BaseObject
    field :end_cursor, String, null: true
    field :start_cursor, String, null: true
    field :has_next_page, Boolean, null: false
    field :has_previous_page, Boolean, null: false
  end
end
