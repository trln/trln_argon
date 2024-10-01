module TrlnArgon
    module Document
        class ActionsComponent < Blacklight::Document::ActionsComponent
            renders_many :actions, (lambda do |action:, component: nil, **kwargs|
                component ||= TrlnArgon::Document::ActionComponent || action.component
                component.new(action: action, document: @document, options: @options, url_opts: @url_opts, link_classes: @link_classes, **kwargs)
              end)
        end
    end
end
  