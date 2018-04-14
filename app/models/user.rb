# frozen_string_literal: true

# User model class
class User < Sequel::Model
  plugin :devise

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable, :recoverable, :rememberable, :trackable,
  #  :confirmable,

  devise :validatable, :registerable, :database_authenticatable

  many_to_one :affiliate
  one_to_many :orders
  one_to_one :car
  one_to_many :refresh_tokens, key: :id

  plugin :association_dependencies
  User.add_association_dependencies refresh_tokens: :delete

  ROLES = [
    ADMIN = 'Admin',
    CLIENT = 'Client',
    DRIVER = 'Driver',
    DISPATCHER = 'Dispatcher',
    MANAGER = 'Manager',
    ACCOUNTANT = 'Accountant'
  ].freeze

  ROLES.each do |r|
    define_method "#{r.downcase}?" do
      role == r
    end
  end

  LANGUAGES = %w[Russian English].freeze
end
