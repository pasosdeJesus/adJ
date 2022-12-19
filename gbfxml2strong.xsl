<?xml version="1.0" encoding="UTF-8"?>

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

<!-- Divide c="123,232,45" en 123>][<232>][<45
     Referencia: http://www.exslt.org/str/functions/tokenize/str.tokenize.template.xsl
     -->
<xsl:template name="divstrong">
	<xsl:param name="c" select="''"/>
	<xsl:variable name="n" select="substring-before($c,',')"/>
	<xsl:variable name="pm" select="substring-after($c,',')"/>
	<xsl:variable name="p" select="substring-before($pm,',')"/>
	<xsl:variable name="mo" select="substring-after($pm,',')"/>
	<xsl:choose>
	    <xsl:when test="contains($mo,';')">
		<xsl:variable name="mt" select="substring-before($mo,';')"/>
		<xsl:variable name="r" select="substring-after($mo,';')"/>
		<xsl:value-of select="$p"/>,<xsl:value-of select="$n"/>,<xsl:value-of select="$mt"/><xsl:text>
</xsl:text>
		<xsl:call-template name="divstrong"><xsl:with-param name="c" select="$r"/></xsl:call-template>
           </xsl:when>
	   <xsl:otherwise>
		<xsl:value-of select="$p"/>,<xsl:value-of select="$n"/>,<xsl:value-of select="$mo"/><xsl:text>
</xsl:text>
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

<!-- Strong style -->
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
	<xsl:param name="lang" select="./@lang"/>
	<xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
	<xsl:variable name="ns" select="substring-after(./@id,'-')"/>
	<xsl:variable name="nc" select="substring-before($ns,'-')"/>
	<xsl:variable name="nv" select="substring-after($ns,'-')"/>
	<xsl:value-of select="$nc"/>:<xsl:value-of select="$nv"/><xsl:text>
</xsl:text>
<!--<xsl:variable name="s">
	<xsl:apply-templates>
		<xsl:with-param name="lang" select="$n"/>
	</xsl:apply-templates>
</xsl:variable> -->

	<xsl:apply-templates>
		<xsl:with-param name="lang" select="$n"/>
	</xsl:apply-templates>
	<!--	<xsl:for-each select="*/wi">
		<xsl:sort select="substring-before(substring-after(./@value,','),',')" 
			data-type="number" />
		<xsl:value-of select="substring-before(substring-after(./@value,','),',')"/>,<xsl:value-of select="substring-before(./@value,',')"/>,<xsl:value-of select="substring-after(substring-after(./@value,','),',')"/>
		<xsl:text>
</xsl:text>
	</xsl:for-each> -->

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

<xsl:template match="wi">	
	<xsl:choose>
		<xsl:when test="./@type='G' or ./@type='G*' or ./@type='GU'">
			<xsl:call-template name="divstrong"><xsl:with-param name="c" select="./@value"/></xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates/>
	<!--		<xsl:with-param name="lang" select="$n"/>
</xsl:apply-templates> -->

</xsl:template>


<!-- Text -->
<xsl:template match="text()">
	<xsl:param name="lang"/>
        <xsl:if test="$lang = $outlang">
		<!--                <xsl:value-of select="."/> -->
        </xsl:if>
</xsl:template>


</xsl:stylesheet>


