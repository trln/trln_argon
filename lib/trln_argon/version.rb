module TrlnArgon
  unless TrlnArgon.const_defined? :VERSION
    def self.version
      @version ||= File.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')).chomp
    end

    VERSION = version.freeze
  end
end
