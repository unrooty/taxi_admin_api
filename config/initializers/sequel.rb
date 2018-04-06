# frozen_string_literal: true

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.db.extension :pg_array, :pg_json
Sequel::Model.plugin :after_initialize

# NOTE: REQUIRES AFTER SEQUEL FOR CORRECT WORK OF MODELS
require 'common_lib'
