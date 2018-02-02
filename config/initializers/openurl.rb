# The OpenURL gem doesn't handle multiple authors
# when returning a context object as kev. This patch
# handles multiple authors in a way that
# Zotero can find them.
module OpenURL
  class ContextObjectEntity
    def kev(abbr)
      kevs = []

      @metadata.each do |k, v|
        if v && !@author_keys.include?(k)
          kevs << "#{abbr}.#{k}=#{CGI.escape(v.to_str)}"
        end
      end

      @authors.each do |author_obj|
        @author_keys.each do |author_key|
          author_values = author_obj.send(author_key)
          if author_values
            author_values.each do |au_v|
              kevs << "#{abbr}.#{author_key}=#{CGI.escape(au_v.to_str)}"
            end
          end
        end
      end

      if @kev_ns
        kevs << "#{abbr}_val_fmt=" + CGI.escape(@kev_ns)
      elsif @format
        kevs << "#{abbr}_val_fmt=" + CGI.escape("info:ofi/fmt:kev:mtx:#{@format}")
      end

      if @reference['format']
        kevs << "#{abbr}_ref_fmt=" + CGI.escape(@reference['format'])
        kevs << "#{abbr}_ref=" + CGI.escape(@reference['location'])
      end

      @identifiers.each do |id|
        kevs << "#{abbr}_id=" + CGI.escape(id)
      end

      kevs << "#{abbr}_dat=" + CGI.escape(@private_data) if @private_data
      kevs
    end
  end
end
