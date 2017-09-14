module TrlnArgon
  class Field < SimpleDelegator
    attr_reader :solr_name, :labels, :label

    def initialize(solr_name, labels)
      @solr_name = solr_name.to_s
      @labels = labels
      super(@solr_name)
    end

    def label
      labels[I18n.locale]
    end
  end
end
