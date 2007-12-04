<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- XSL to convert from GBF XML in HTML -->
<!-- Source released to the public domain 2003 vtamara@informatik.uni-kl.de -->

<!-- Modularity ideas from http://nwalsh.com/docs/articles/dbdesign/ -->
<!DOCTYPE xsl:stylesheet []>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" out="text"
	xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl">


<xsl:param name="outlang">es</xsl:param>
<xsl:variable name="numf" select="1"/>


<xsl:output method="html" encoding="ISO-8859-1"/>


<!-- Entry point -->
<xsl:template match="gbfxml">
	<xsl:variable name="titulo">
		<xsl:apply-templates select="tt">
		</xsl:apply-templates>
	</xsl:variable>

  <html><head>
		  <title><xsl:value-of select="$titulo"/></title>
	<link rel="stylesheet" type="text/css" href="biblia_dp.css" />
	</head><xsl:text>
    </xsl:text>
    <body>
    <xsl:text>
    </xsl:text>
    <h1><xsl:value-of select="$titulo"/></h1> 
    <!--	  <xsl:apply-templates select=".//stt">
	</xsl:apply-templates>-->
		<xsl:text> 
		</xsl:text>
		<font size="-1" class="srights-title">
		<a href="#srights">Derechos</a> | 
		<a href="#credits">Cr�ditos</a>
		</font>
		<!--	  <xsl:apply-templates select=".//rights">
			</xsl:apply-templates><xsl:text> 
          </xsl:text>  -->
    <xsl:apply-templates select=".//sb">
    </xsl:apply-templates><xsl:text>
    </xsl:text>
    <h3>Derechos</h3>
    <a name="#srights"/>
	<xsl:apply-templates select=".//rights">
	</xsl:apply-templates><xsl:text> 
</xsl:text>  
    <h3>Cr�ditos</h3>
    <a name="#credits"/>
	<xsl:apply-templates select="credits" mode="footnotes">
	</xsl:apply-templates><xsl:text> 
</xsl:text>  
    <h3>Notas al pie</h3>
    <a name="#footnotes"/>
    <xsl:apply-templates select=".//sb" mode="footnotes">
    </xsl:apply-templates><xsl:text>
    </xsl:text>
    <h3>Referencias</h3>
    <a name="#references"/>
    <xsl:apply-templates select=".//sbib">
    </xsl:apply-templates><xsl:text>
    </xsl:text> 

  </body></html>
</xsl:template>

<!-- Short title -->
<xsl:template match="tt"> 
	<xsl:apply-templates/>
</xsl:template>


<!-- Long title -->
<xsl:template match="stt">
	<h1><xsl:apply-templates/></h1>
</xsl:template>

<!-- Copyright notice  -->
<xsl:template match="srights">
  <p>
  <xsl:apply-templates>
  </xsl:apply-templates>
  </p>
</xsl:template> 

<!-- Long copyright notice -->
<xsl:template match="rights">
  <p>
	  <xsl:apply-templates>
  </xsl:apply-templates></p>
</xsl:template>

<!-- Book --> 
<xsl:template match="sb">
  <div class="sb"><xsl:text>
</xsl:text>
<!--	<xsl:variable name="titulo">
		<xsl:apply-templates select="tt">
		</xsl:apply-templates>
	</xsl:variable>
	<h2><xsl:value-of select="$titulo"/>
		<a href="#fn0"><sup>0</sup></a>
	</h2> -->
    <xsl:text>
    </xsl:text>
	<xsl:apply-templates select=".//sc">
	</xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="sb" mode="footnotes">
	<xsl:apply-templates select="//sc" mode="footnotes">
	</xsl:apply-templates>
</xsl:template>

	
<!-- Credits -->
<xsl:template match="credits">
</xsl:template>

<xsl:template match="credits" mode="footnotes">
  <p><xsl:apply-templates>
  </xsl:apply-templates></p>
</xsl:template>


<!-- Sub-book in psalms -->
<xsl:template match="tb">
  <h4>
	  <xsl:value-of select="./@title"/></h4>
  <xsl:apply-templates>
  </xsl:apply-templates>
</xsl:template>

<!-- Chapter -->
<xsl:template match="sc">
     <xsl:variable name="numcap" select="substring-after(./@id,'-')"/>
     <div class="sect1" id="{./@id}">
	<!--    <font size="+2"><xsl:value-of select="$num"/></font> -->
    <xsl:apply-templates select="cm[position()=1]">
	    <xsl:with-param name="numcap" select="$numcap"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="*[position()>1]">
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="sc" mode="footnotes">
	<xsl:apply-templates mode="footnotes">
	</xsl:apply-templates>
</xsl:template>

<!-- Comment -->
<xsl:template match="tc">
</xsl:template>


<!-- Paragraph of chapter -->
<xsl:template match="cm">
	<xsl:param name="numcap"/>
  <xsl:text>
  </xsl:text>
  <p class="{./@type}">
	<xsl:if test="$numcap!=''">
		<font size="+2"><xsl:value-of select="$numcap"/></font>
	</xsl:if>
<xsl:apply-templates>
  </xsl:apply-templates></p>
</xsl:template>

<xsl:template match="cm" mode="footnotes">
	<xsl:apply-templates mode="footnotes">
	</xsl:apply-templates>
</xsl:template>

<!-- URL -->
<xsl:template match="url">
  <a href="{.}"><xsl:value-of select="."/></a>
</xsl:template>

<!-- Strong -->
<xsl:template match="fb">
  <b class="strong">
	  <xsl:apply-templates>
  </xsl:apply-templates></b>
</xsl:template>

<xsl:template match="fb" mode="footnotes">
  <b class="strong">
	<xsl:apply-templates mode="footnotes">
  </xsl:apply-templates></b>
</xsl:template>


<!-- Small Caps -->
<xsl:template match="fc">
  <xsl:apply-templates>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="fc" mode="footnotes">
	<xsl:apply-templates mode="footnotes">
  </xsl:apply-templates>
</xsl:template>



<!-- Old testament quote -->
<xsl:template match="fo">
  <blockquote>
	<xsl:value-of select="."/>
  </blockquote>
</xsl:template>

<xsl:template match="fo" mode="footnote">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>


<!-- Words of Jesus -->
<xsl:template match="fr">
  <font color="red" class="fr">
  <xsl:apply-templates>
  </xsl:apply-templates>
  </font>
</xsl:template>

<xsl:template match="fr" mode="footnote">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>


<!-- Superscript -->
<xsl:template match="fs">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>

<!-- Underline -->
<xsl:template match="fu">
  <u class="underline">
	  <xsl:apply-templates>
  </xsl:apply-templates></u>
</xsl:template>

<xsl:template match="fu" mode="footnotes">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>


<!-- Subscript -->
<xsl:template match="fv">
  <sub>
	  <xsl:apply-templates>
  </xsl:apply-templates></sub>
</xsl:template>

<xsl:template match="fv" mode="footnotes">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>

<!-- Break line -->
<xsl:template match="cl">
	<br/>
  <xsl:text>
</xsl:text>
</xsl:template>

<!-- Poetry -->
<xsl:template match="pp">
  <blockquote>
	  <xsl:apply-templates>
  </xsl:apply-templates>
  </blockquote>
</xsl:template>

<xsl:template match="pp" mode="footnotes">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>


<!-- Verse -->
<xsl:template match="sv">
	<xsl:variable name="num1"><xsl:value-of select='substring-after(./@id,"-")'/></xsl:variable>
	<xsl:variable name="num"><xsl:value-of select='substring-after($num1,"-")'/></xsl:variable>
	<xsl:text> </xsl:text>
	<sup class="verse" id="{./@id}"><xsl:value-of select="$num"/></sup>
	<xsl:apply-templates>
  </xsl:apply-templates>

</xsl:template>

<xsl:template match="sv" mode="footnotes">
	<xsl:apply-templates mode="footnotes">
	</xsl:apply-templates>
</xsl:template>

<xsl:key name="footnote" match="rb" use="."/>

<!-- Text with embedded footnote  --> 
<xsl:template match="rb">
	<!-- Numeraci�n con base en num. pies de p�ginas de Docbook (N. Walsh) -->
	<xsl:variable name="pf" select="preceding::rb"/>
	<xsl:variable name="pf2" select="preceding::rb[@xml:lang='es']"/>
	<xsl:variable name="pf3" select="preceding::rb/t[@xml:lang='es']"/>
	<xsl:variable name="nf" select="count($pf) + 1"/>
	<xsl:variable name="nf2" select="count($pf2)"/>
	<xsl:variable name="nf3" select="count($pf3)"/>
	<xsl:variable name="ct">
		<xsl:apply-templates select="rf" mode="write-footnotes">
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:if test="$ct!=''"> 
		<a name="b_{generate-id(key('footnote',.))}"/>
		<a href="#{generate-id(key('footnote',.))}" class="footnote">
			<xsl:apply-templates/>
			<sup>[<xsl:value-of select="$nf2+$nf3+1"/>]</sup></a>
	</xsl:if>
</xsl:template>

<xsl:template match="rb" mode="footnotes">
	<xsl:variable name="pf" select="preceding::rb"/>
	<xsl:variable name="pf2" select="preceding::rb[@xml:lang='es']"/>
	<xsl:variable name="pf3" select="preceding::rb/t[@xml:lang='es']"/>
	<xsl:variable name="nf" select="count($pf) + 1"/>
	<xsl:variable name="nf2" select="count($pf2)"/>
	<xsl:variable name="nf3" select="count($pf3)"/>
	<xsl:variable name="ct">
		<xsl:apply-templates select="rf" mode="write-footnotes">
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:if test="$ct!=''">
		<p><a name="{generate-id()}"/>[<a href="#b_{generate-id()}" class="bfootnote"><xsl:value-of select="$nf2+$nf3+1"/></a>]
			<xsl:copy-of select="$ct"/>
		</p>
	</xsl:if>
</xsl:template>


<!-- Footnote -->
<xsl:template match="rf">
</xsl:template>


<xsl:template match="rf" mode="write-footnotes">
	<xsl:apply-templates mode="write-footnotes">
	</xsl:apply-templates>
</xsl:template>


<!-- Word information -->
<xsl:template match="wi">
  <xsl:apply-templates>
  </xsl:apply-templates>
</xsl:template>

<!-- Parallel passage -->
<xsl:template match="rp">
</xsl:template>

<!-- Cross reference -->
<xsl:template match="rx">
</xsl:template>

<!-- Cite to bibliography -->
<xsl:template match="citebib">
  <a href="#bib_{./@id}">
  <xsl:value-of select="./@id"/></a>
</xsl:template>

<xsl:template match="citebib" mode="write-footnotes">
  <a href="#bib_{./@id}">
  <xsl:value-of select="./@id"/></a>
</xsl:template>


<!-- Translation -->
<xsl:template match="t">
	  <xsl:if test="lang($outlang)">
	  	<xsl:apply-templates>
		</xsl:apply-templates>
	  </xsl:if>
</xsl:template>

<xsl:template match="t" mode="footnotes"/>

<xsl:template match="t" mode="write-footnotes">
	<xsl:if test="lang($outlang)">
	  	<xsl:apply-templates>
		</xsl:apply-templates>
	  </xsl:if>
</xsl:template>


<!-- Text -->
<xsl:template match="text()">
	<xsl:if test="lang($outlang)">
       		<xsl:value-of select="."/>
	</xsl:if>
</xsl:template>

<xsl:template match="text()" mode="footnotes">
</xsl:template>


<xsl:template match="text()" mode="write-footnotes">
	<xsl:if test="lang($outlang)">
		<xsl:value-of select="."/>
	</xsl:if>
</xsl:template>


<!-- Section of bibliography -->
<xsl:template match="sbib">
  <div class="bibliography">
    <xsl:apply-templates>
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="bib">
  <p>
    <a name="#bib_{./@id}">[<xsl:value-of select="./@id"/>]</a>
    <xsl:apply-templates>
    </xsl:apply-templates>
  </p>
</xsl:template>

<xsl:template match="author">
  <font class="author">
	<xsl:apply-templates>
    </xsl:apply-templates>
  </font>
</xsl:template>

<xsl:template match="editor">
  <font class="editor">
	  <xsl:apply-templates>
    </xsl:apply-templates>
  </font>
</xsl:template>

<xsl:template match="otherbib">
  <font class="publisher">
	  <xsl:apply-templates>
    </xsl:apply-templates>
  </font>
</xsl:template>


</xsl:stylesheet>


