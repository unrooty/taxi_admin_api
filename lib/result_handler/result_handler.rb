module ResultHandler
  include Matcher

  def handle_successful(result)
    match(%w[success unauthorized not_found]).call(result) do |m|
      m.success do
        form_and_model_return(result)
        yield if block_given?
      end
      m.unauthorized { unauthorized_error }
      m.not_found { not_found_error }
    end
  end

  def handle_invalid(result)
    match(%w[invalid fail]).call(result) do |m|
      m.invalid do
        form_and_model_return(result)
        yield if block_given?
      end
      m.fail { failure(result) }
    end
  end

  def unauthorized_error
    error!('Forbidden', 403)
  end

  def not_found_error
    error!('Not Found', 404)
  end

  def failure(result)
    error!(result[:errors][:message], result[:errors][:status])
  end

  def form_and_model_return(result)
    @model = result[:model]
    @contract = result['contract.default']
  end
end
