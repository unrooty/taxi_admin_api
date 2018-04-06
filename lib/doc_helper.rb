# frozen_string_literal: true

# Contains helper methods for documentation. Extra codes can be

module DocHelper
  def self.swagger_client_description
    <<~HEREDOC
      API that provides functionality for Taxi Station application.

      This is the description of client path of API.

      Write **/api/v1/admin/docs.json** instead of **/api/v1/docs.json**
      into search bar of this page to read the description of admin path.
    HEREDOC
  end

  def self.swagger_admin_description
    <<~HEREDOC
      API that provides functionality for Taxi Station application.

      This is the description of admin path of API.

      **NOTE:** Valid Access Token must be present in
      api_key field (placed at the top of this page) for each request.
      To get Access Token, please, visit client path of API.

      Write **/api/v1/docs.json** instead of **api/v1/admin/docs.json**
      into search bar of this page to read the description of client path."
    HEREDOC
  end

  def self.access_note
    <<~HEREDOC


      **Note:** Access Token must be present in
      api_key field (placed at the top of this page)
      for success.
    HEREDOC
  end

  def self.index_codes(model, *extra_status_codes)
    codes = [
      {
        code: 200,
        message: "Array of #{model}.",
        model: "V1::Entities::#{model.classify.constantize}"
      },
      {
        code: 401,
        message: 'No access token present or token invalid.',
        model: V1::Entities::AccessError
      },
      {
        code: 403,
        message: 'Access forbidden.',
        model: V1::Entities::AccessError
      },
      {
        code: 500,
        message: 'Server Error',
        model: V1::Entities::ApiError
      }
    ]

    return codes if extra_status_codes.nil?

    extra_status_codes.each { |c| codes.push(c) }
    codes
  end

  def self.show_codes(model, *extra_status_codes)
    codes = [
      {
        code: 200,
        message: "Single #{model}.",
        model: "V1::Entities::#{model.classify.constantize}"
      },
      {
        code: 401,
        message: 'No access token present or token invalid.',
        model: V1::Entities::AccessError
      },
      {
        code: 403,
        message: 'Access forbidden.',
        model: V1::Entities::AccessError
      },
      {
        code: 404,
        message: "#{model.capitalize} with id not found.",
        model: V1::Entities::ClientError
      },
      {
        code: 500,
        message: 'Server Error',
        model: V1::Entities::ApiError
      }
    ]
    return codes if extra_status_codes.nil?

    extra_status_codes.each { |c| codes.push(c) }
    codes
  end

  def self.create_codes(model, *extra_status_codes)
    codes = [
      {
        code: 201,
        message: "#{model.capitalize} created.",
        model: "V1::Entities::#{model.classify.constantize}"
      },
      {
        code: 400,
        message: 'One or more params missed.',
        model: V1::Entities::ClientError
      },
      {
        code: 401,
        message: 'No access token present or token invalid.',
        model: V1::Entities::AccessError
      },
      {
        code: 403,
        message: 'Access forbidden.',
        model: V1::Entities::AccessError
      },
      {
        code: 422,
        message: 'One or more params has invalid value.',
        model: V1::Entities::ClientError
      },
      {
        code: 500,
        message: 'Server Error.',
        model: V1::Entities::ApiError
      }
    ]

    return codes if extra_status_codes.nil?

    extra_status_codes.each { |c| codes.push(c) }
    codes
  end

  def self.update_codes(model, *extra_status_codes)
    codes = [
      {
        code: 200,
        message: "#{model.capitalize} updated.",
        model: "V1::Entities::#{model.classify.constantize}"
      },
      {
        code: 400,
        message: 'One or more params missed.',
        model: V1::Entities::ClientError
      },
      {
        code: 401,
        message: 'No access token present or token invalid.',
        model: V1::Entities::AccessError
      },
      {
        code: 403,
        message: 'Access forbidden.',
        model: V1::Entities::AccessError
      },
      {
        code: 422,
        message: 'One or more params has invalid value.',
        model: V1::Entities::ClientError
      },
      {
        code: 404,
        message: "#{model.capitalize} with id not found.",
        model: V1::Entities::ClientError
      },
      {
        code: 500,
        message: 'Server Error',
        model: V1::Entities::ApiError
      }
    ]

    return codes if extra_status_codes.nil?

    extra_status_codes.each { |c| codes.push(c) }
    codes
  end

  def self.delete_codes(model, *extra_status_codes)
    codes = [
      {
        code: 204,
        message: "#{model.capitalize} deleted."
      },
      {
        code: 401,
        message: 'No access token present or token invalid.',
        model: V1::Entities::AccessError
      },
      {
        code: 403,
        message: 'Access forbidden.',
        model: V1::Entities::AccessError
      },
      {
        code: 404,
        message: "#{model.capitalize} with id not found.",
        model: V1::Entities::ClientError
      },
      {
        code: 500,
        message: 'Server Error.',
        model: V1::Entities::ApiError
      }
    ]

    return codes if extra_status_codes.nil?

    extra_status_codes.each { |c| codes.push(c) }
    codes
  end
end
