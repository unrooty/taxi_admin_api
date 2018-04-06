class RefreshToken < Sequel::Model
  many_to_one :user
end
