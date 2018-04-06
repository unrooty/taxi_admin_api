class Tax
  module Contract
    class Create < Reform::Form
      #:property
      property :name
      property :cost_per_km
      property :basic_cost
      #:property end

    end
  end
end
