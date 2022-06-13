<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output omit-xml-declaration="yes" method="html" indent="yes" encoding="UTF-8"/>
	<xsl:param name="copyright">
         <div class="syndetics-copyright">
          Content provided by Syndetic Solutions, Inc.
          <a href='https://syndetics.com/termsofuse.html' rel='nofollow noopener noreferrer'>Terms of Use</a>
        </div>
        </xsl:param>
	<xsl:template match="AVSUMMARY">
		<!-- display the summary portion (Syndetics assures us that an AVSUMMARY nodeset has either a Fld500 *or* a Fld520, but not both), as long as the summary doesn't consist solely of a copyright notice -->
		<xsl:variable name="summary-data" select="//Notes/Fld520/a|//Notes/Fld500/a"/>
		<xsl:if test="not(substring(normalize-space($summary-data),1,9) = 'Copyright')">
			<section class="avReview">
				<p>
					<xsl:apply-templates select="$summary-data" mode="structured" />
				</p>
				<xsl:copy-of select="$copyright"/>
			</section>
		</xsl:if>
	</xsl:template>
	<xsl:template match="a">
		<!-- this template does a copy-of to preserve HTML elements in the <a> node -->
		<xsl:if test="descendant-or-self::node()/text()">
			<xsl:copy-of select="child::node()"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
