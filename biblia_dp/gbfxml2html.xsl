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


<xsl:output method="html" version="4.0" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" encoding="ISO-8859-1"/>


<xsl:key name="numstrong" match="//wi" use="substring-before(./@value,',')"/>

<!-- Entry point -->
<xsl:template match="gbfxml">
	<xsl:variable name="titulo">
		<xsl:apply-templates select="sb/tt">
		</xsl:apply-templates>
	</xsl:variable>

  <html><head>
		  <title><xsl:value-of select="$titulo"/></title>
		  <link rel="stylesheet" type="text/css" href="biblia_dp.css" />
		  <script type="text/javascript">
<xsl:comment>
function changeIt() {
	if (!document.styleSheets) return;
	var theRules = new Array();
	if (document.styleSheets[0].cssRules)
		theRules = document.styleSheets[0].cssRules
	else if (document.styleSheets[0].rules)
		theRules = document.styleSheets[0].rules
	else return;
	var result = null;
	for(var c = 0; c &lt; theRules.length; c++) {
		if(theRules[c].selectorText == "sup.strong") {
			result = theRules[c].style;
			break;
		}
	}

	if (result) {
		var e=document.getElementById("mostrarStrong");
		if (e.checked) {
			result.display = "inline";
		}
		else {
			result.display = "none";
		}
	}
}
</xsl:comment>
		  </script>

	</head><xsl:text>
    </xsl:text>
    <body>
	    <xsl:text>
    </xsl:text>
    <h1><xsl:value-of select="$titulo"/></h1> 
    <xsl:text> 
    </xsl:text>
    <span class="srightstitle">
	    <a href="#srights">Términos</a> | 
	    <a href="#credits">Créditos</a>
    </span>
    <div align="right">
	    <input name="mostrarStrong" type="checkbox" checked="checked"
		    id="mostrarStrong" onclick="changeIt();"/>
	    <label for="mostrarStrong">Números Strong</label>
    </div>

    <xsl:apply-templates select=".//sb">
    </xsl:apply-templates><xsl:text>
    </xsl:text> 
    <a name="strong"/>
    <h3>Números Strong</h3>
    <ul> 
    <!-- http://www.dpawson.co.uk/xsl/sect2/N4486.html -->
    <xsl:for-each select=".//wi[@type='G' and generate-id(.)=generate-id(key('numstrong', substring-before(@value,',')))]" >
	    <xsl:sort select="substring-before(@value, ',')" 
		    data-type="number"/>
	    <xsl:variable name="ns"><xsl:copy-of 
			    select="substring-before(@value, ',')"/>
	    </xsl:variable>
	    <li><a name="st{$ns}"/><xsl:value-of select="$ns"/>
		    <xsl:text>: </xsl:text>
		    <xsl:for-each select="key('numstrong',substring-before(@value, ','))">	
			    <xsl:variable name="nw" select="substring-before(substring-after(@value, ','),',')"/>
			    <xsl:variable name="nver" select="ancestor::sv/@id"/>
			    <xsl:value-of select="."/><xsl:text> </xsl:text>

			    <xsl:for-each select="following-sibling::wi[@type='GC' and @value=$nw]">
				    <xsl:text> ... </xsl:text>
			    	    <xsl:value-of select="."/>
			    </xsl:for-each>
			    <xsl:text> </xsl:text>
			    <a href="#{$nver}">
				    <xsl:value-of select="$nver"/>
			    </a>
			<xsl:text> </xsl:text>
		</xsl:for-each>
	    </li>
    </xsl:for-each> 
    </ul>
    <xsl:text>
    </xsl:text>
    <a name="footnotes"/>
    <h3>Notas al pie</h3>
    <xsl:apply-templates select=".//sb" mode="footnotes">
    </xsl:apply-templates><xsl:text>
    </xsl:text>
    <a name="srights"/>
    <h3>Términos</h3>
	<xsl:apply-templates select=".//rights">
	</xsl:apply-templates><xsl:text> 
    </xsl:text>  
    <a name="credits"/>
    <h3>Créditos</h3>
    <xsl:apply-templates select=".//credits">
	</xsl:apply-templates><xsl:text> 
    </xsl:text>  
    <a name="references"/>
    <h3>Referencias</h3>
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
	</h2> 
    <xsl:text>
    </xsl:text> -->
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
	<a name="{./@id}"/>
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
  <p class="cm{./@type}">
	<xsl:if test="$numcap!=''">
		<span class="numchapter"><xsl:value-of select="$numcap"/></span>
	</xsl:if>
<xsl:apply-templates>
  </xsl:apply-templates></p>
</xsl:template>

<xsl:template match="cm" mode="footnotes">
	<xsl:apply-templates mode="footnotes"/>
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
	  <xsl:apply-templates mode="footnotes"/>
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
  <span class="fr">
  <xsl:apply-templates>
  </xsl:apply-templates>
  </span>
</xsl:template>

<xsl:template match="fr" mode="footnote">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>

<!-- Superscript -->
<xsl:template match="fs">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="fs" mode="footnotes">
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
	<a name="{./@id}"/>
	<sup class="verse" id="{./@id}"><xsl:value-of select="$num"/></sup>
	<xsl:apply-templates>
  </xsl:apply-templates>

</xsl:template>

<xsl:template match="sv" mode="footnotes">
	<xsl:apply-templates mode="footnotes"/>
</xsl:template>

<!-- Text with embedded footnote  --> 
<xsl:key name="footnote" match="rb" use="."/>

<xsl:template match="rb">
	<!-- Numeración con base en num. pies de páginas de Docbook (N. Walsh) -->
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
			<xsl:apply-templates/></a>
		<a href="#{generate-id(key('footnote',.))}" class="footnote">
			<sup class="footnote">[<xsl:value-of select="$nf2+$nf3+1"/>]</sup></a>
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
	<xsl:apply-templates mode="write-footnotes"/>
</xsl:template>

<!-- Word information -->
<xsl:template match="wi">
	<xsl:param name="interior"/>
	<xsl:variable name="ns" select="substring-before(./@value,',')"/>
	<xsl:choose>
		<xsl:when  test="$ns!=''">
			<u class="strong">
				<xsl:apply-templates>
					<xsl:with-param name="interior" select="1"/>	
				</xsl:apply-templates>
				<sup class="strong"><a href="#st{$ns}" class="strong">
						<xsl:value-of select="$ns"/></a>
					<xsl:if test="$interior='1'">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</sup>
			</u>
		</xsl:when>
		<xsl:when  test="./@type='GC'">
			<u class="strong">
				<xsl:apply-templates>
					<xsl:with-param name="interior" select="1"/>	
				</xsl:apply-templates>
				<xsl:variable name="ps" select="concat(@value,',')"/>
				<xsl:variable name="pf3" select="preceding-sibling::wi[substring-after(@value, ',')=$ps]"/>
				<xsl:variable name="ns2" select="substring-before($pf3/@value,',')"/>
				<sup class="strong"><a href="#st{$ns2}" class="strong">
				<xsl:value-of select="$ns2"/></a>
				<xsl:if test="$interior='1'">
					<xsl:text>,</xsl:text>
				</xsl:if>
				</sup>
			</u>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
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
		  <xsl:apply-templates/>
	  </xsl:if>
</xsl:template>

<xsl:template match="t" mode="footnotes"/>

<xsl:template match="t" mode="write-footnotes">
	<xsl:if test="lang($outlang)">
		<xsl:apply-templates/>
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
	  <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="bib">
  <p>
    <a name="bib_{./@id}">[<xsl:value-of select="./@id"/>]</a>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="author">
  <span class="author">
	  <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="editor">
  <span class="editor">
	  <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="otherbib">
  <span class="publisher">
	  <xsl:apply-templates/>
  </span>
</xsl:template>


</xsl:stylesheet>


