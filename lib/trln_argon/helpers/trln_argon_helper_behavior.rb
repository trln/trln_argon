module TrlnArgon
  module TrlnArgonHelperBehavior

    def entry_name(count)
      entry = t("blacklight.entry_name.default")
      count.to_int == 1 ? entry : entry.pluralize
    end

    def institution_code_to_short_name options={}
      options[:value].map do |value|
        t("trln_argon.local_institution.#{value}.short_name")
      end.join("; ")
    end

    def institution_short_name
      t("trln_argon.local_institution.#{TrlnArgon::Engine.configuration.local_institution_code}.short_name")
    end

    def institution_long_name
      t("trln_argon.local_institution.#{TrlnArgon::Engine.configuration.local_institution_code}.long_name")
    end

    def consortium_short_name
      t("trln_argon.consortium.short_name")
    end

    def consortium_long_name
      t("trln_argon.consortium.long_name")
    end

    def filter_scope_name
      if controller_name == 'bookmarks'
        t('trln_argon.scope_name.bookmarks')
      else
        local_filter_applied? ? institution_short_name : consortium_short_name
      end
    end

  end
end
