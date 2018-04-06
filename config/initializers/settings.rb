# frozen_string_literal: true

SETTINGS_PATH = "#{Rails.root}/config/settings.yml"
APP_SETTINGS = YAML.load_file(SETTINGS_PATH)[Rails.env]
