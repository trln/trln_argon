module TrlnArgon
  # Put any shared overrides of BlacklightHelperBehavior
  # in this module. Overrides in the local TRLN Argon based
  # applications go in app/helpers/blacklight_helper.rb
  module ViewHelpers
    module BlacklightHelperBehavior
      include Blacklight::BlacklightHelperBehavior

      def application_name
        TrlnArgon::Engine.configuration.application_name
      end

      def show_subjects_presenter(document)
        TrlnArgon::ShowSubjectsPresenter.new(document, self)
      end

      def show_authors_presenter(document)
        TrlnArgon::ShowAuthorsPresenter.new(document, self)
      end

      def show_related_works_presenter(document)
        TrlnArgon::ShowRelatedWorksPresenter.new(document, self)
      end

      def show_included_works_presenter(document)
        TrlnArgon::ShowIncludedWorksPresenter.new(document, self)
      end

      def show_sub_header_presenter(document)
        TrlnArgon::ShowSubHeaderPresenter.new(document, self)
      end
    end
  end
end
