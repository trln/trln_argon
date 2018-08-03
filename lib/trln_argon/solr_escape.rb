module TrlnArgon
  module SolrEscape
    # Example: 'foo : foo' => 'foo \\: foo'
    # Escaping ' :' to ' \\:' prevents Solr edismax query parser
    # from parsing 'foo : foo' into foo:[[66 6f 6f] TO [66 6f 6f]]
    def self.escape_colon_after_space(str)
      str.gsub(/\s:/, ' \\\\:')
    end

    def self.unescape_colon_after_space(str)
      str.gsub(/\s\\:/, ' :')
    end
  end
end
