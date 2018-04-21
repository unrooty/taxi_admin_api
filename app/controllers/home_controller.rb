# frozen_string_literal: true

require 'rails/application_controller'
class HomeController < Rails::ApplicationController
  def index
    render file: Rails.root.join('public', 'index.html.erb')
  end
end
