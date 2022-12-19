<?xml version="1.0" encoding="UTF-8"?>

<!-- XSL to convert from GBF XML in GBF DocBook XML -->
<!-- Source released to the public domain 2002 vtamara@informatik.uni-kl.de -->

<!DOCTYPE xsl:stylesheet [

<!ENTITY docbook.id "-//WEB//DTD General Bible Format on DocBook XML V4.1.2//EN">
<!-- Could be "-//OASIS//DTD DocBook V4.1//EN"
	or "-//OASIS//DTD DocBook XML V4.1.2//EN" -->

<!ENTITY docbook.url "gbfdbxml.dtd">
<!-- Could be "http://www.oasis-open.org/docbook"
	or "http://www.oasis-open.org/docbook/xml/4.0/docbookx.dtd" -->

]>

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
  <xsl:choose>
    <xsl:when test="./@lang = ''">
      <xsl:value-of select="$lang"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="./@lang"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:output method="xml" doctype-public="&docbook.id;" encoding="UTF-8" omit-xml-declaration="no" doctype-system="&docbook.url;" />


<!-- Entry point -->
<xsl:template match="gbfxml">
  <xsl:param name="lang" select="./@lang"/>
  <set lang="{$outlang}"><xsl:text>
    </xsl:text>
	<setinfo>
	  <xsl:apply-templates select="./tt">
		  <xsl:with-param name="lang" select="$lang"/>
	  </xsl:apply-templates>

    <xsl:text>
    </xsl:text>
	  <xsl:apply-templates select=".//stt">
		<xsl:with-param name="lang" select="$lang"/>
	  </xsl:apply-templates><xsl:text>
          </xsl:text>
	  <xsl:apply-templates select=".//rights">
		<xsl:with-param name="lang" select="$lang"/>
	  </xsl:apply-templates><xsl:text>
          </xsl:text>
	</setinfo>
    <xsl:apply-templates select=".//sb">
    	<xsl:with-param name="lang" select="$lang"/>
    </xsl:apply-templates><xsl:text>
    </xsl:text>
    <xsl:apply-templates select=".//sbib">
    	<xsl:with-param name="lang" select="$lang"/>
    </xsl:apply-templates><xsl:text>
    </xsl:text>
  </set>
</xsl:template>

<!-- Short title -->
<xsl:template match="tt"> 
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <title><xsl:apply-templates>
	  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></title>
</xsl:template>

<!-- Long title -->
<xsl:template match="stt">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <titleabbrev><xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></titleabbrev>
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
  <article><xsl:text>
    </xsl:text>
    <xsl:apply-templates select=".//tt">
	<xsl:with-param name="lang" select="$n"/>
    </xsl:apply-templates><xsl:text>
    </xsl:text>
    <footnote><para>
	<xsl:apply-templates select=".//credits">
    	<xsl:with-param name="lang" select="$n"/>
      </xsl:apply-templates>
    </para></footnote>
    <xsl:apply-templates select=".//sc">
	<xsl:with-param name="lang" select="$n"/>
    </xsl:apply-templates>
  </article>
</xsl:template>

<!-- Credits -->
<xsl:template match="credits">
  <xsl:param name="lang" select="./@lang"/>
  Versión: <xsl:value-of select="./@version"/>. 
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <xsl:apply-templates>
  <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>


<!-- Sub-book in psalms -->
<xsl:template match="tb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <brighthead><xsl:value-of select="./@title"/></brighthead>
  <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Chapter -->
<xsl:template match="sc">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <sect1 id="{./@id}">
    <title><xsl:value-of select="./@num"/></title>
    <xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
    </xsl:apply-templates>
    
  </sect1>
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
  <para>
<xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></para>
</xsl:template>

<!-- URL -->
<xsl:template match="url">
  <ulink url="{.}"><xsl:value-of select="."/></ulink>
</xsl:template>


<!-- Email -->
<xsl:template match="email">
  <email><xsl:value-of select="."/></email>
</xsl:template>


<!-- Strong -->
<xsl:template match="fb">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <emphasis role="strong"><xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></emphasis>
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
  <quote><xsl:value-of select="."/></quote>
</xsl:template>

<!-- Words of Jesus -->
<xsl:template match="fr">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <fr><xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></fr>
</xsl:template>

<!-- Superscript -->
<xsl:template match="fs">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <superscript><xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></superscript>
</xsl:template>

<!-- Underline -->
<xsl:template match="fu">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <emphasis role="underline"><xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></emphasis>
</xsl:template>

<!-- Subscript -->
<xsl:template match="fv">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <subscript><xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></subscript>
</xsl:template>

<!-- Break line -->
<xsl:template match="cl">
<screen>
</screen>
</xsl:template>

<!-- Poetry -->
<xsl:template match="pp">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <blockquote><xsl:apply-templates>
	<xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates>
  </blockquote>
</xsl:template>

<!-- Verse -->
<xsl:template match="sv">
  <xsl:text> </xsl:text><superscript role="verse" id="{./@id}"><xsl:value-of select="./@num"/></superscript>
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
  <footnote><para><xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></para></footnote>
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
  <citation><link linkend="{./@id}"><xsl:value-of select="./@id"/></link></citation>
</xsl:template>

<!-- Translation -->
<xsl:template match="t">
	<xsl:if test="./@lang = $outlang">
		<xsl:value-of select="."/>
	</xsl:if>
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
  <bibliography><para><xsl:apply-templates>
    <xsl:with-param name="lang" select="$n"/>
  </xsl:apply-templates></para></bibliography>
</xsl:template>

<xsl:template match="bib">
  <xsl:param name="lang" select="./@lang"/>
  <xsl:variable name="n"><xsl:call-template name="newlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template></xsl:variable>
  <biblioentry id="{./@id}">
	<xsl:apply-templates select="./tt">
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates>
	<publisher>
	<xsl:apply-templates select="./author">
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates><xsl:text> </xsl:text>
	<xsl:apply-templates select="./editor">
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates><xsl:text> </xsl:text>
	<xsl:apply-templates select="./otherbib">
	 <xsl:with-param name="lang" select="$n"/>
	 </xsl:apply-templates><xsl:text> </xsl:text>
	</publisher>
  </biblioentry>
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


