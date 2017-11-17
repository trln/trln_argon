<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output omit-xml-declaration="yes" method="html" indent="yes" encoding="UTF-8"/>
	<xsl:template match="AVSUMMARY">
		<!-- display the summary portion (Syndetics assures us that an AVSUMMARY nodeset has either a Fld500 *or* a Fld520, but not both), as long as the summary doesn't consist solely of a copyright notice -->
		<xsl:variable name="summary-data" select="//Notes/Fld520/a|//Notes/Fld500/a"/>
		<xsl:if test="not(substring(normalize-space($summary-data),1,9) = 'Copyright')">
			<section class="avReview">
				<p>
					<xsl:apply-templates select="$summary-data" mode="structured" />
				</p>
				<xsl:call-template name="copyright-generator" />
			</section>
		</xsl:if>
	</xsl:template>
	<xsl:template match="a">
		<!-- this template does a copy-of to preserve HTML elements in the <a> node -->
		<xsl:if test="descendant-or-self::node()/text()">
			<xsl:copy-of select="child::node()"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="copyright-generator">
		<div>
			<xsl:attribute name="class">syndeticscopyrightblock</xsl:attribute>
			<xsl:text>Content provided by Syndetic Solutions, Inc.  </xsl:text>
			<xsl:call-template name="hyperlink-generator">
				<xsl:with-param name="href" select="'http://syndetics.com/termsofuse.htm'" />
				<xsl:with-param name="link-text" select="'Terms of Use'" />
				<xsl:with-param name="external-link-indicator" select="'yes'" />
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="hyperlink-generator">
		<xsl:param name="href" />
		<xsl:param name="link-text" />
		<xsl:param name="external-link-indicator" />
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$href"/>
			</xsl:attribute>
			<xsl:if test="$external-link-indicator = 'yes'">
				<xsl:attribute name="class">externallink</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$link-text"/>
		</a>
	</xsl:template>
</xsl:stylesheet>