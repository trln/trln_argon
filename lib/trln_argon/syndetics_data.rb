module TrlnArgon
  module XMLHandler; end

  # encapsulation of various kinds of enriched catalog data from Syndetics,
  # including cover images, tables of contents, summaries, author notes,
  # reviews and track listings for AV materials.
  #
  # In general, for each kinds of data two methods exist, one with a ? at
  # the end to determine whether the data is present, and
  # another to fetch the data (usually HTML, but sometimes plain text or a URL)
  #
  # See the names of the ELEMENTS constant for furter details.
  #
  # ELEMENTS is hash that describes the attributes and common operation
  # of this class.  Each key corresponds to an attribute that might be found
  # in the Syndetics data, and translates to a query method (ending in ?)
  # and an access method (using hte key).  Each name is associated with a data
  # hash that defines how to extract the attribute from the XML document.
  # :path indicates the element to be extracted for a simple text extraction,
  # :path_required indicates that :path must be present for the query method
  # IN ADDITION TO :element, if the query method matches the input document.
  # :bigtext indicates that the field is often simple text, but might be long
  # and not have line breaks, in which case we will try to output it as a
  # set of paragraphs.
  # :transformer if present, a proc/block/method that should be invoked on a
  # document rooted at :element to extract the content.
  # rubocop:disable Metrics/ClassLength
  class SyndeticsData
    include XMLHandler
    COVERS = { SC: 'small', MC: 'medium', LC: 'large' }.freeze

    COPYRIGHT = %(
      <div class='syndetics-copyright'>
      Content provided by Syndetic Solutions, Inc.
      <a href='http://syndetics.com/termsofuse.htm'
       rel='nofollow noopener noreferrer'>Terms of Use</a>
       </div>).freeze

    def self.read_stylesheet(name)
      File.read(File.join(File.dirname(__FILE__), 'xslt', "#{name}.xsl"))
    end

    def self.compile_stylesheet(xslt_string)
      Nokogiri::XSLT.parse(xslt_string)
    end

    def self.transform_element(xslt, element)
      doc = Nokogiri::XML::Document.new
      doc.root = element
      xslt.transform(doc).serialize.strip.html_safe
    end

    def self.transform_toc(tocelement)
      @toc_xslt ||= compile_stylesheet(read_stylesheet('toc'))
      transform_element(@toc_xslt, tocelement)
    end

    def self.transform_avreview(avelement)
      @avreview_xslt ||= compile_stylesheet(read_stylesheet('av-review'))
      transform_element(@avreview_xslt, avelement)
    end

    def self.transform_avtracklist(avelement)
      @avtracklist_xslt ||= compile_stylesheet(read_stylesheet('av-tracks'))
      transform_element(@avtracklist_xslt, avelement)
    end

    # some fields have a wall of text; this tries to find places
    # that should be line breaks
    # wraps each chunk in <p> tags
    def post_process_bigtext(txt)
      # multiple nbsp surrounded by spaces
      result = txt.split(/\s+\du00ao+\s+/).map { |x| "<p>#{x.strip}</p>" }.join(' ')
      # sometimes there are <p> tags already in there ...
      result.gsub(%r{(<\/?p>){2,}}, '\1')
    end

    ELEMENTS = {
      summary: {
        element: 'SUMMARY',
        path: './/Fld520',
        bigtext: true
      },
      toc: {
        element: 'TOC',
        transformer: method(:transform_toc)
      },
      authornotes: {
        element: 'ANOTES',
        path: 'VarDFlds/SSIFlds/Fld980',
        bigtext: true
      },
      samplechapter: {
        element: 'DBCHAPTER',
        path: './/Fld520',
        bigtext: true
      },
      avsummary: {
        element: 'AVSUMMARY',
        path: '//SSIFlds/Fld520'
      },
      avreview: {
        element: 'AVSUMMARY',
        path: 'AVSUMMARY[//Fld520|//Fld500]',
        path_required: true,
        transformer: method(:transform_avreview)
      },
      avtracklist: {
        element: 'AVSUMMARY',
        path: 'AVSUMMARY//Fld970[1]',
        path_required: true,
        transformer: method(:transform_avtracklist)
      },
      smallcover: {
        element: 'SC',
        path: 'text()'
      },
      medcover: {
        element: 'MC',
        path: 'text()'
      },
      lgcover: {
        element: 'LC',
        path: 'text()'
      }
    }.freeze

    # dynamically create query and extract methods
    ELEMENTS.each do |attr, data|
      define_method :"#{attr.to_s}?" do
        return false unless @present.include?(data[:element])
        data[:path_required] ? !@doc.root.xpath(data[:path]).first.nil? : true
      end

      define_method :"#{attr.to_s}" do
        return '' unless @present.include?(data[:element])
        data_element = @doc.root.xpath(data[:element]).first
        return data[:transformer].call(data_element) if data[:transformer]
        return '' if data_element.nil?
        element_data = data_element.xpath(data[:path])
        if !element_data.nil? && !element_data.first.nil?
          result = element_data.first.text
          result = (data[:bigtext] ? post_process_bigtext(result) : result)
          return (result + COPYRIGHT).html_safe
        end
        ''
      end
    end

    def initialize(doc)
      @doc = doc
      @covers = Hash[COVERS.map do |elname, size|
        txt = doc.xpath("#{elname}/text()").first
        [size, txt.text] if txt
      end.select(&:itself)]
      @present = doc.root.children.map(&:name)
    end
  end
  # rubocop:enable Metrics/ClassLength
end
