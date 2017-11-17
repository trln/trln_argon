<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes"
        encoding='utf-8' />

    <xsl:template match="/">
        <xsl:apply-templates match="VarFlds/VarDFlds/SSIFlds"/>
    </xsl:template>

    <xsl:template match="text()|@*"/>
    <xsl:template match='SSIFlds'>
   <ul class='toc'>
     <xsl:for-each select='Fld970'>
       <li>
           <xsl:apply-templates select="l|t|p"/>
       </li>
    </xsl:for-each>
   </ul>
  </xsl:template>

   <xsl:template match="l">
     <span class="toc-element-number">
      <xsl:value-of select="."/>
  </span>
  <xsl:text>&#160;</xsl:text>
  </xsl:template>
  <xsl:template match="t">
     <span class="toc-element-title">
       <xsl:value-of select="."/>
   </span>
  </xsl:template>

  <xsl:template match="p">
      <xsl:text>&#160;</xsl:text>
    <span class="toc-element-pagerange">
       <xsl:value-of select='.'/>
     </span>
  </xsl:template>
</xsl:stylesheet>
