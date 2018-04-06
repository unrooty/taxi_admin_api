# frozen_string_literal: true

class User
  class Show < Trailblazer::Operation
    step Model(User, :[])

    step Policy::Pundit(UsersPolicy, :can_manage?)
  end
end
