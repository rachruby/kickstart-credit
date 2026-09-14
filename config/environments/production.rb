Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # Serve static files + precompiled assets (no CDN/nginx in front on
  # simple hosts like Render/Fly).
  config.public_file_server.enabled = true

  # The host terminates TLS and forwards plain HTTP; trust its headers.
  config.assume_ssl = true
  config.force_ssl = false

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.logger = ActiveSupport::Logger.new($stdout)
                                       .tap { |l| l.formatter = Logger::Formatter.new }
                                       .then { |l| ActiveSupport::TaggedLogging.new(l) }

  config.active_record.dump_schema_after_migration = false

  # Allow the deploy host through Host Authorization.
  config.hosts << ENV["APP_HOST"] if ENV["APP_HOST"].present?
  config.hosts << /.*\.onrender\.com/
end
