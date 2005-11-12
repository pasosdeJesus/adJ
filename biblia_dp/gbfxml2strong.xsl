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

<!-- Ignora morfología en número Strong. s="123:N-X" 
     lo convierte en {<123>} (N-X) -->
     <xsl:template name="un_strong">
		<xsl:param name="s" select="''"/>
		<xsl:text>{&lt;</xsl:text>
		<xsl:value-of select="$s"/>
		<xsl:text>&gt;}</xsl:text>
	</xsl:template>
	<!--	<xsl:param name="s" select="''"/>
	<xsl:choose>
		<xsl:when test="not($s)">
		</xsl:when>
		<xsl:when test="contains($s, ':')">
			<xsl:text>{&lt;</xsl:text>
			<xsl:value-of select="substring-before($s, ':')"/>
			<xsl:text>&gt;}(</xsl:text>
			<xsl:value-of select="substring-after($s, ':')"/>
			<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>{&lt;</xsl:text>
			<xsl:value-of select="$s"/>
			<xsl:text>&gt;}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> -->


<!-- Divide c="123,232,45" en 123>][<232>][<45
     Referencia: http://www.exslt.org/str/functions/tokenize/str.tokenize.template.xsl
     -->
<xsl:template name="divstrong">
	<xsl:param name="c" select="''"/>
	<xsl:choose>
		<xsl:when test="not($c)">
		</xsl:when>
		<xsl:when test="contains($c, ',')">
			<xsl:call-template name="un_strong">
				<xsl:with-param name="s" select="substring-before($c,',')"/>
			</xsl:call-template>
			<xsl:call-template name="divstrong">
				<xsl:with-param name="c" select="substring-after($c,',')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="un_strong">
				<xsl:with-param name="s" select="$c"/>
			</xsl:call-template>
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
	<xsl:choose>
		<xsl:when test="./@n != ''">
			<xsl:call-template name="un_strong">
				<xsl:with-param name="s" select="./@n"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="divstrong">
				<xsl:with-param name="c" select="./@c"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Text -->
<xsl:template match="text()">
	<xsl:param name="lang"/>
        <xsl:if test="$lang = $outlang">
		<!--                <xsl:value-of select="."/> -->
        </xsl:if>
</xsl:template>


</xsl:stylesheet>


