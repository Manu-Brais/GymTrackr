module DryMonadsHelper
  extend ActiveSupport::Concern

  included do
    include Dry::Monads[:result]
  end
end
