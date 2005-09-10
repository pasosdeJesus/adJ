<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- XSL to convert from GBF XML to a sequence of Strong numbers -->
<!-- Source released to the public domain 2005.
     No warranties.
     vtamara@pasosdejesus.org -->

<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="outlang">es</xsl:param>
<xsl:param name="lang">en</xsl:param>


<!-- functions not supported by xsltproc 1004
<xsl:function name="new_lang">
  <xsl:param name="attlang"/>
  <xsl:param name="lang"/>
  <xsl:variable name="res">
    <xsl:choose>
	<xsl:when  test="$attlang=''">
	  <xsl:value-of select="$lang"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$attlang"/>
	</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:result select="$res"/>
</xsl:function>
-->

<!-- To use with call-template -->
<xsl:template name="newlang">
	<xsl:param name="lang"/>
	<xsl:variable name="langloc"><xsl:value-of select="./@lang"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$langloc = ''">
			<xsl:value-of select="$lang"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="./@lang"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:output method="text" />

<!-- Entry point -->
<xsl:template match="gbfxml">
  <xsl:param name="lang" select="./@lang"/>
    <xsl:apply-templates select=".//sb">
    	<xsl:with-param name="lang" select="$lang"/>
    </xsl:apply-templates>
</xsl:template>


<!-- Book --> 
<xsl:template match="sb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
    <xsl:apply-templates select=".//sc">
	<xsl:with-param name="lang" select="$n"/>
    </xsl:apply-templates>
</xsl:template>


<!-- Chapter -->
<xsl:template match="sc">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
    <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
    </xsl:apply-templates>
</xsl:template>

<!-- Paragraph of chapter -->
<xsl:template match="cm">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
<xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Strong -->
<xsl:template match="fb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Small Caps -->
<xsl:template match="fc">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Words of Jesus -->
<xsl:template match="fr">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Superscript -->
<xsl:template match="fs">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Underline -->
<xsl:template match="fu">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Subscript -->
<xsl:template match="fv">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Break line -->
<xsl:template match="cl">
</xsl:template>

<!-- Poetry -->
<xsl:template match="pp">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Verse -->
<xsl:template match="sv">
<xsl:text>
</xsl:text>
	<xsl:value-of select="./@id"/>
<xsl:text>: </xsl:text>
</xsl:template>

<!-- Text with embedded footnote  --> 
<xsl:template match="rb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Footnote -->
<xsl:template match="rf">
</xsl:template>

<!-- Word information -->
<xsl:template match="wi">
</xsl:template>

<!-- Parallel passage -->
<xsl:template match="rp">
</xsl:template>

<!-- Cross reference -->
<xsl:template match="rx">
</xsl:template>

<!-- Cite to bibliography -->
<xsl:template match="citebib">
</xsl:template>

<!-- Translation -->
<xsl:template match="t">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
	<xsl:apply-templates>
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates>
</xsl:template>

<!-- Section of bibliography -->
<xsl:template match="sbib">
</xsl:template>

<xsl:template match="bib">
</xsl:template>

<xsl:template match="author">
</xsl:template>

<xsl:template match="editor">
</xsl:template>

<xsl:template match="otherbib">
</xsl:template>

<xsl:template match="st">
	<xsl:text>{&lt;</xsl:text>
	<xsl:value-of select="./@n"/>
	<xsl:value-of select="./@c"/>
	<xsl:text>&gt;}</xsl:text>
</xsl:template>


<!-- Text -->
<xsl:template match="text()">
	<xsl:param name="lang"/>
        <xsl:if test="$lang = $outlang">
		<!--                <xsl:value-of select="."/> -->
        </xsl:if>
</xsl:template>


</xsl:stylesheet>


