class Order
  module Contract
    class Create < Reform::Form
      #:property
      property :start_point
      property :end_point
      property :client_name
      property :client_phone
      #:property end
    end
  end
end
