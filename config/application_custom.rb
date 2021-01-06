module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :de
    available_locales = [:de, :en]
  end
end
