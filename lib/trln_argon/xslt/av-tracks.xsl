<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output omit-xml-declaration="yes" method="html" indent="yes" encoding="UTF-8"/>
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
		<div class="syndeticscopyrightblock">
            Content provided by Syndetic Solutions, Inc.
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