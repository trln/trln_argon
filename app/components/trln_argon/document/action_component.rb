module TrlnArgon
    module Document
      class ActionComponent < Blacklight::Document::ActionComponent
        def label
          Rails.logger.debug("TrlnArgon::Document::ActionComponent#label")
          if @action.key?(:icon)
            content_tag(:i, '', class: @action[:icon].to_s, 'aria-hidden' => 'true') + ' ' +
              t("blacklight.tools.#{@action.name}", default: @action.label || @action.name.to_s.humanize)
          else
            t("blacklight.tools.#{@action.name}", default: @action.label || @action.name.to_s.humanize)
          end
        end        
      end
    end
  end