# frozen_string_literal: true

class DryService
  include Dry::Monads[:result, :do, :maybe, :try]

  class << self
    # Instantiates and calls the service at once
    def call(*, &)
      new(*).call(&)
    end

    # Accepts both symbolized and stringified attributes
    def new(*args)
      hsh = args.pop.symbolize_keys if args.last.is_a?(Hash)
      super(*args, **(hsh || {}))
    end
  end
end
