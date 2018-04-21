# frozen_string_literal: true

module Handler
  # MATCHERS = []
  def handle(result, *)
    if result.success?
      @model = result[:model]
      return yield if block_given? # For grape mostly
      return @model # For graphql mostly
    end
    return failure(result) if result.failure?
    error('Something went wrong! Please, try again or contact the developer!', 500)
  end

  def failure(result)
    return error('Forbidden', 403) if result['result.policy.default']&.failure?
    return error('Not Found', 404) if result['result.model']&.failure?
    return error(result[:errors][:message], result[:errors][:status]) if result[:errors]
    error(result['contract.default'].errors.full_messages.join(', '), 422)
  end

  def error(msg, status = nil)
    raise RequestError.new(msg, status)
  end

  class RequestError < StandardError

    attr_reader :status

    def initialize(message, status = nil)
      @status = status || 400
      super(message)
    end
  end
end
