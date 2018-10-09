class AdvancedTrlnController < AdvancedController
  copy_blacklight_config_from(TrlnController)

  private

  def search_action_url(options = {})
    url_for(options.merge(controller: 'trln', action: 'index'))
  end

  def advanced_search_url(options = {})
    trln_argon.url_for(options.merge(controller: 'advanced_trln', action: 'index'))
  end
end
