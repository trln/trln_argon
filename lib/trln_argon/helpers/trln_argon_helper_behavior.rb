module TrlnArgon
  module TrlnArgonHelperBehavior

    def entry_name(count)
      entry = t("blacklight.entry_name.default")
      count.to_int == 1 ? entry : entry.pluralize
    end

    def institution_short_name
      t("blacklight.local_institution.#{TrlnArgon::Engine.configuration.local_institution}.short_name")
    end

    def institution_long_name
      t("blacklight.local_institution.#{TrlnArgon::Engine.configuration.local_institution}.long_name")
    end

    def consortium_short_name
      t("blacklight.consortium.short_name")
    end

    def consortium_long_name
      t("blacklight.consortium.long_name")
    end

    def filter_scope_name
      if controller_name == 'bookmarks'
        t('blacklight.scope_name.bookmarks')
      else
        local_filter_applied? ? institution_short_name : consortium_short_name
      end
    end

  end
end
