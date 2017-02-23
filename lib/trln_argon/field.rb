module TrlnArgon

  class Field < SimpleDelegator

    attr_reader :base

    def initialize(base, *args)
      @base = base.to_s
      name = @base
      super(name)
    end

    def label
      I18n.t "#{i18n_base}.label", default: base.titleize
    end


    private

    def i18n_base
      "trln_argon.fields.#{base}"
    end

  end

end
