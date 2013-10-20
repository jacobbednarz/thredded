Thredded::Application.configure do
  config.eager_load = false
  config.force_ssl = false
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = true
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default charset: 'utf-8'

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
end
