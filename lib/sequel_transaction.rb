# frozen_string_literal: true

class SequelTransaction
  extend Uber::Callable

  def self.call((_ctx, _flow_options), *)
    Sequel::Model.db.transaction { yield }
  end
end
