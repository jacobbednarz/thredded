Thredded::Application.configure do
  config.eager_load = true
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = 'X-Sendfile'

  config.serve_static_assets = false
  config.assets.compile = false
  config.assets.compress = true
  config.assets.digest = true
  config.assets.js_compressor  = :uglifier

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
end
