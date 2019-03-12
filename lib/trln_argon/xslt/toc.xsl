<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes"
        encoding='utf-8' />
        <xsl:param name="copyright">
         <div class="syndetics-copyright">
          Content provided by Syndetic Solutions, Inc. 
          <a href='https://syndetics.com/termsofuse.htm' rel='nofollow noopener noreferrer'>Terms of Use</a>
        </div>
        </xsl:param>

    <xsl:template match="/">
        <xsl:apply-templates match="VarFlds/VarDFlds/SSIFlds"/>
        <xsl:copy-of select="$copyright" />
    </xsl:template>

    <xsl:template match="text()|@*"/>
    <xsl:template match='SSIFlds'>

   <ul class='toc'>
     <xsl:for-each select='Fld970'>
       <li>
         <xsl:attribute name="class">
           <xsl:call-template name="toc-item-class">
             <xsl:with-param name="indexed" select="@I1" />
             <xsl:with-param name="nest-level" select="@I2" />
           </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="l|t|p|c"/>
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

  <xsl:template match="c">
      <xsl:text>&#160;</xsl:text>
    <span class="toc-element-author">
       <xsl:value-of select='.'/>
     </span>
  </xsl:template>

  <xsl:template name="toc-item-class">
    <xsl:param name="indexed" />
    <xsl:param name="nest-level" />

    <xsl:if test="string-length($nest-level)>0">
      <xsl:text>toc-nest-level-</xsl:text>
      <xsl:value-of select="$nest-level" />
    </xsl:if>

    <xsl:if test="$indexed != '1'">
      <xsl:text> toc-nonindexed</xsl:text>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
