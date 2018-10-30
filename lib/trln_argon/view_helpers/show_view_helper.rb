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
        'col-md-12 title-and-thumbnail'
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
        'other-details'
      end

      def show_authors_class
        'show-authors'
      end

      def show_items_class
        'holdings'
      end

      def show_enhanced_data_class
        'enhanced-data'
      end

      def show_enhanced_data_summary_class
        'summary'
      end

      def show_enhanced_data_toc_class
        'table-of-contents'
      end

      def show_enhanced_data_sample_chapter_class
        'sample-chapter'
      end

      def show_included_works_class
        'show-included-works'
      end

      def show_subjects_class
        'show-subjects'
      end

      def show_related_works_class
        'show-related-works'
      end
    end
  end
end
