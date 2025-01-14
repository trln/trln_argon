module TrlnArgon
  module Document
    class ActionComponent < Blacklight::Document::ActionComponent
      # rubocop:disable Style/StringConcatenation
      def label
        (content_tag(:i, '', class: @action[:icon].to_s, 'aria-hidden' => true) + ' ' if @action.key?(:icon)).to_s +
          t("blacklight.tools.#{@action.name}", default: @action.label || @action.name.to_s.humanize).html_safe
      end
      # rubocop:enable Style/StringConcatenation
    end
  end
end
