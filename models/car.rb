# Car model class
class Car < Sequel::Model
  many_to_one :affiliate
  one_to_one :user, key: :id
  one_to_many :orders
  STATUSES = [
    FREE = 'Free'.freeze,
    ORDERED = 'Ordered'.freeze
  ].freeze

  STATUSES.each do |status|
    define_method "#{status.downcase}?" do
      car_status == status
    end
  end
end
