<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output omit-xml-declaration="yes" method="html" indent="yes" encoding="UTF-8"/>
	<xsl:param name="copyright">
		<div class="syndetics-copyright">
          Content provided by Syndetic Solutions, Inc.
          <a href='https://syndetics.com/termsofuse.html' rel='nofollow noopener noreferrer'>Terms of Use</a>
      	</div>
        </xsl:param>
	<xsl:template match="/AVSUMMARY">
		<xsl:variable name="av-tracks" select="//SSIFlds/Fld970" />
		<xsl:if test="$av-tracks">
			<section class="avTracks">
				<p class="shaded label">Tracks</p>
                <ul class="syndeticstoclist">
                    <xsl:apply-templates select="$av-tracks"/>
                </ul>
                <xsl:call-template name="copyright-generator" />
			</section>
		</xsl:if>
	</xsl:template>
	<xsl:template match="a" mode="structured">
		<!-- this template does a copy-of to preserve HTML elements in the <a> node -->
		<xsl:if test="descendant-or-self::node()/text()">
			<xsl:copy-of select="child::node()"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Fld970">
		<xsl:if test="l/text() or t/text()">
			<li class="leveltwo">
				<xsl:if test="l/text()">
					<xsl:value-of select="concat(l, '. ')"/>
				</xsl:if>
				<xsl:if test="t/text()">
					<xsl:value-of select="t"/>
				</xsl:if>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template name="copyright-generator">
		<xsl:copy-of select="$copyright" />
	</xsl:template>


</xsl:stylesheet>
