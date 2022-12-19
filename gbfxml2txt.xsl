<?xml version="1.0" encoding="UTF-8"?>

<!-- XSL to convert from GBF XML in Text -->
<!-- Source released to the public domain 2003.
     No warranties.
     vtamara@informatik.uni-kl.de -->

<!DOCTYPE xsl:stylesheet [
]>

<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="outlang">es</xsl:param>
<xsl:param name="lang">en</xsl:param>



<!-- To use with call-template -->
<xsl:template name="newlang">
  <xsl:param name="lang"/>
  <xsl:choose>
    <xsl:when test="./@lang = ''">
      <xsl:value-of select="$lang"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="./@lang"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:output method="text" encoding="UTF-8" />


<!-- Entry point -->
<xsl:template match="gbfxml">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:apply-templates select=".//sb">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:apply-templates><xsl:text>

  </xsl:text>
  <xsl:apply-templates select=".//sbib">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:apply-templates><xsl:text>
  </xsl:text>
</xsl:template>

<!-- Title -->
<xsl:template match="tt"> 
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Short title -->
<xsl:template match="stt">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Copyright notice  -->
<xsl:template match="srights">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template> 

<!-- Long copyright notice -->
<xsl:template match="rights">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <legalnotice><para><xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></para></legalnotice>
</xsl:template>

<!-- Book --> 
<xsl:template match="sb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates select=".//tt">
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates><xsl:text>
[Nota al pie: </xsl:text><xsl:apply-templates select=".//credits">
    	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
  <xsl:text>]

  </xsl:text>
  <xsl:apply-templates select=".//sc">
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
  <xsl:text>]
</xsl:text>
</xsl:template>

<!-- Credits -->
<xsl:template match="credits">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:text>Versión: </xsl:text><xsl:value-of select="./@version"/>
  <xsl:text>.  </xsl:text> 
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>


<!-- Sub-book in psalms -->
<xsl:template match="tb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:value-of select="./@title"/>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Chapter -->
<xsl:template match="sc">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:text>
</xsl:text>
  <xsl:value-of select="./@num"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates>
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
  <xsl:text>
</xsl:text>
</xsl:template>

<!-- Comment -->
<xsl:template match="tc">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
</xsl:template>


<!-- Paragraph of chapter -->
<xsl:template match="cm">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates>
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- URL -->
<xsl:template match="url">
  <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text>
</xsl:template>

<!-- Email -->
<xsl:template match="email">
  <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text>
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

<!-- Old testament quote -->
<xsl:template match="fo">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:value-of select="."/>
</xsl:template>

<!-- Words of Jesus -->
<xsl:template match="fr">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:text></xsl:text><xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates><xsl:text></xsl:text>
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
	<xsl:text>
</xsl:text>
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
  <xsl:text> </xsl:text><xsl:value-of select="./@num"/>
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
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:variable name="t"> 
    <xsl:apply-templates>
      <xsl:with-param name="lang" select="$n"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$t = ''">
    </xsl:when>
    <xsl:otherwise>
  	<xsl:text>[Nota al pie: </xsl:text><xsl:apply-templates>
		    <xsl:with-param name="lang" select="$n"/>
		</xsl:apply-templates><xsl:text>]
</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
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
  <xsl:text>[</xsl:text><xsl:value-of select="./@id"/><xsl:text>]</xsl:text>
</xsl:template>

<!-- Translation -->
<xsl:template match="t">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
	<xsl:apply-templates>
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates>
</xsl:template>

<!-- Text -->
<xsl:template match="text()">
 <xsl:param name="lang"/>
        <xsl:if test="$lang = $outlang">
                <xsl:value-of select="."/>
        </xsl:if>
</xsl:template>

<!-- Section of bibliography -->
<xsl:template match="sbib">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:text>
Bibliografía</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="bib">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:text>[</xsl:text><xsl:value-of select="./@id"/><xsl:text>] </xsl:text>
	<xsl:apply-templates select="./tt">
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates><xsl:text> </xsl:text>
	<xsl:apply-templates select="./author">
	 <xsl:with-param name="lang" select="$n"/>
	</xsl:apply-templates><xsl:text> </xsl:text>
	<xsl:apply-templates select="./editor">
	 <xsl:with-param name="lang" select="$n"/>
	</xsl:apply-templates><xsl:text> </xsl:text>
	<xsl:apply-templates select="./otherbib">
	 <xsl:with-param name="lang" select="$n"/>
	</xsl:apply-templates><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="author">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="editor">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="otherbib">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>


