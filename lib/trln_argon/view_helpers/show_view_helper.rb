module TrlnArgon
  module ViewHelpers
    module ShowViewHelper
      # Hooks to control classes set on content divs in show view
      # Can be used to control layout. Create a local copy of TrlnArgonHelper
      # include the Argon gem helper module and then override the methods
      # as needed.
      #
      # FOR EXAMPLE: LOCAL APP FILE: app/helpers/trln_argon_helper.rb
      #
      # module TrlnArgonHelper
      #   include TrlnArgon::ViewHelpers::TrlnArgonHelper
      #
      #   def show_class
      #     'col-md-12'
      #   end
      # end

      def show_class
        'col-md-12 show-document'
      end

      def show_main_content_heading_partials_class
        'col-md-12'
      end

      def show_main_content_partials_class
        'col-md-10'
      end

      def show_tools_class
        'col-md-12'
      end

      def show_sub_header_class; end

      def show_thumbnail_class
        'blacklight thumbnail'
      end

      def show_other_details_class
        'full-record-section'
      end

      def show_authors_class
        'full-record-section'
      end

      def show_items_class
        'full-record-section'
      end

      def show_enhanced_data_class; end

      def show_enhanced_data_summary_class
        'full-record-section'
      end

      def show_enhanced_data_toc_class
        'full-record-section'
      end

      def show_enhanced_data_sample_chapter_class
        'full-record-section'
      end

      def show_included_works_class
        'full-record-section'
      end

      def show_subjects_class
        'full-record-section'
      end

      def show_related_works_class
        'full-record-section'
      end

      def display_summary?(options = {})
        display_enhanced_data?(options, :syndetics_or_marc_summary)
      end

      def display_toc?(options = {})
        display_enhanced_data?(options, :syndetics_or_marc_toc)
      end

      def display_sample_chapter?(options = {})
        display_enhanced_data?(options, :syndetics_or_marc_sample_chapter)
      end

      def display_other_details?(options = {})
        display_configured_fields?(options, :show_fields)
      end

      def display_authors?(options = {})
        display_configured_fields?(options, :show_authors_fields)
      end

      def display_subjects?(options = {})
        display_configured_fields?(options, :show_subjects_fields)
      end

      def display_related_works?(options = {})
        display_configured_fields?(options, :show_related_works_fields)
      end

      def display_included_works?(options = {})
        display_configured_fields?(options, :show_included_works_fields)
      end

      private

      def display_configured_fields?(options, field_config)
        doc = options.fetch(:document, false)
        doc && show_configured_fields_and_values(blacklight_config.send(field_config), doc).any?
      end

      def display_enhanced_data?(options, accessor)
        doc = options.fetch(:document, false)
        doc && doc.send(accessor).present?
      end
    end
  end
end
