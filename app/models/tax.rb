# Tax model class.
class Tax < Sequel::Model
  one_to_many :orders
end
