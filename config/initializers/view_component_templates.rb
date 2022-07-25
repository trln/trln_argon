require 'trln_argon/component_template_watcher'

# Adds watchers that copy Blacklight (etc.) component templates
# from the gem's directories into a running application, but only
# in development mode when the application is run by Engine Cart
# ensures updates to component templates are found by the Blacklight
# mechanism that allows overriding just the templates
Rails.application.configure do |_|
  if Rails.env.development? && Rails.root.to_s.include?('.internal_test_app')
    Rails.logger.info('Starting watchers on bundled blacklight viewcomponents')
    TrlnArgon::ComponentTemplateWatcher.new.start!
  end
end
