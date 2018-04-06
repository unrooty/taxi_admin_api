class User
  module Contract
    class Create < Reform::Form
      include ActiveModel::Validations
      #:property
      property :first_name
      property :last_name
      property :phone
      property :email
      property :affiliate_id
      property :role
      property :language
      property :password
      property :password_confirmation
      property :city
      property :address
      #:property end

      #:validation
      validates :password, confirmation: true
      validates :email, uniqueness: true
      #:validation end
    end
  end
end
