# require 'app/lib/validator/unique_validator
class Affiliate
  module Contract
    class Create < Reform::Form
      include ActiveModel::Validations
      #:property
      property :name
      property :address
      #:property end

      #:validation
      validates :name, uniqueness: true
    end
  end
end
