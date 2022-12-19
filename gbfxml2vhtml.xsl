<?xml version="1.0" encoding="UTF-8"?>
<!--  vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker:  -->

<!-- XSL to convert from GBF XML in HTML -->
<!-- Source released to the public domain 2003 vtamara@pasosdeJesus.org -->
<!-- Vladimir Támara Patiño -->

<!-- Modularity ideas from http://nwalsh.com/docs/articles/dbdesign/ -->
<!DOCTYPE xsl:stylesheet []>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" out="text"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

<!-- Language to produce -->
<xsl:param name="outlang">es</xsl:param>
<!-- CSS file to use -->
<xsl:param name="css">biblia_dp.css</xsl:param>
<xsl:param name="js">biblia_dp.js</xsl:param>


<xsl:output method="html" version="4.0" 
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" 
    encoding="UTF-8"/>

<xsl:key name="numstrong" match="//wi" use="substring-before(./@value,',')"/>

<!-- ** Routines to use with call-template -->

<!-- De https://stackoverflow.com/questions/3067113/xslt-string-replace -->
<xsl:template name="string-replace-all">
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
    <xsl:when test="$text = '' or $replace = ''or not($replace)" >
      <!-- Prevent this routine from hanging -->
      <xsl:value-of select="$text" />
    </xsl:when>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text,$replace)" />
      <xsl:value-of select="$by" />
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="substring-after($text,$replace)" />
        <xsl:with-param name="replace" select="$replace" />
        <xsl:with-param name="by" select="$by" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Header of page -->
<xsl:template name="encabezado">
    <xsl:param name="titulo"/>
    <xsl:param name="nstrong"/>
    <head>
        <title><xsl:value-of select="$titulo"/></title>
        <link rel="stylesheet" type="text/css" href="{$css}" />
        <xsl:if test="$nstrong!='no'">
            <script defer='defer' src="{$js}" />
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
        </xsl:if>
    </head>
<xsl:text>
</xsl:text>
</xsl:template>


<!-- Navigation bar -->
<xsl:template name="navegacion">
    <xsl:param name="anterior"/>
    <xsl:param name="siguiente"/>
    <xsl:param name="tdc"/>
    <table width="100%">
        <tr>
            <td>
                <xsl:if test="$anterior!=''">
                    <a href="{$anterior}">Anterior</a>
                </xsl:if>
            </td>
            <td>
                <xsl:if test="$tdc!=''">
                    <a href="{$tdc}">TdC</a>
                </xsl:if>
            </td>
            <td align="right">
                <xsl:if test="$siguiente!=''">
                    <a href="{$siguiente}">Siguiente</a>
                </xsl:if>
            </td>
        </tr>
    </table>
</xsl:template>


<!-- Layout of one page -->
<xsl:template name="pagina">
    <xsl:param name="href"/>
    <xsl:param name="titulo"/>
    <xsl:param name="nstrong"/>
    <xsl:param name="anterior"/>
    <xsl:param name="siguiente"/>
    <xsl:param name="tdc"/>
    <xsl:param name="contenido"/>
    <xsl:variable name="nav">
        <xsl:call-template name="navegacion">
            <xsl:with-param name="anterior" select="$anterior"/>
            <xsl:with-param name="siguiente" select="$siguiente"/>
            <xsl:with-param name="tdc" select="$tdc"/>
        </xsl:call-template>
    </xsl:variable>

    <exsl:document href="{$href}" method="html" version="4.0" 
        doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" 
        encoding="UTF-8">
        <html>
            <xsl:call-template name="encabezado">
                <xsl:with-param name="titulo" select="$titulo"/>
                <xsl:with-param name="nstrong" select="$nstrong"/>
            </xsl:call-template>
            <body>
                <center><h3><xsl:value-of select="$titulo"/></h3></center>
                <div class="navarriba" align="center">
                    <xsl:copy-of select="$nav"/>
                </div>
                <xsl:if test="$nstrong!='no'">
                    <div align="right">
                        <input name="mostrarStrong" type="checkbox" 
                            checked="checked" id="mostrarStrong" 
                            onclick="changeIt();"/>
                        <label for="mostrarStrong">Números Strong</label>
                    </div>
                </xsl:if>
                <hr/>
                <xsl:copy-of select="$contenido"/>
                <hr/>
                <div class="navabajo" align="center">
                    <xsl:copy-of select="$nav"/>
                </div>
            </body>
        </html>
    </exsl:document>
</xsl:template>
 

<!-- ** Entry point -->
<xsl:template match="gbfxml">
    <xsl:variable name="titulo">
        <xsl:apply-templates select="tt">
        </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="fc" select="sb//sc[position()=1]"/>
    <xsl:variable name="lc" select="sb//sc[position()=last()]"/>
    <xsl:variable name="primerc">
        <xsl:if test="$fc!=''">
            <xsl:value-of select="concat($fc/@id,'.html')"/>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="lastc">
        <xsl:if test="$lc!=''">
            <xsl:value-of select="concat($lc/@id,'.html')"/>
        </xsl:if>
    </xsl:variable>

    <xsl:call-template name="pagina">
        <xsl:with-param name="href">html/index.html</xsl:with-param>
        <xsl:with-param name="titulo" select="$titulo"/>
        <xsl:with-param name="nstrong">no</xsl:with-param>
        <xsl:with-param name="siguiente" select="$primerc"/>
        <xsl:with-param name="contenido">
            <center><h1><xsl:value-of select="$titulo"/></h1>
                <h3>Tabla de Contenido</h3></center>
            <ul>
                <xsl:apply-templates select=".//sb" mode="tdc"/>
                <li> <a href="strong.html">Números Strong</a></li>
                <li> <a href="terminos.html">Términos y Créditos</a> </li>
                <li> <a href="referencias.html">Referencias</a></li>
            </ul>
        </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates select=".//sb">
        <xsl:with-param name="titulo" select="$titulo"/>
    </xsl:apply-templates>

    <xsl:call-template name="pagina">
        <xsl:with-param name="href">html/strong.html</xsl:with-param>
        <xsl:with-param name="titulo">Números Strong</xsl:with-param>
        <xsl:with-param name="nstrong">no</xsl:with-param>
        <xsl:with-param name="anterior" select="$lastc"/>
        <xsl:with-param name="siguiente">terminos.html</xsl:with-param>
        <xsl:with-param name="tdc">index.html</xsl:with-param>
        <xsl:with-param name="contenido">
            <ul>
                <xsl:comment>Ideas tomadas de http://www.dpawson.co.uk/xsl/sect2/N4486.html</xsl:comment>
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
                            <xsl:variable name="ver" select="ancestor::sv/@id"/>
                            <xsl:variable name="nver" select="substring-after($ver,'-')"/>
                            <xsl:variable name="fver" select="concat(substring-before($ver,'-'),'-',substring-before($nver,'-'),'.html')"/>
                            <xsl:value-of select="."/><xsl:text> </xsl:text>

                            <xsl:for-each select="following-sibling::wi[@type='GC' and @value=$nw]">
                                <xsl:text> ... </xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:for-each>
                            <xsl:text> </xsl:text>
                            <a href="{$fver}#{$ver}">
                                <xsl:value-of select="$ver"/>
                            </a>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </li>
                </xsl:for-each> 
            </ul>
        </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="pagina">
        <xsl:with-param name="href">html/terminos.html</xsl:with-param>
        <xsl:with-param name="titulo">Términos y Créditos</xsl:with-param>
        <xsl:with-param name="anterior">strong.html</xsl:with-param>
        <xsl:with-param name="siguiente">referencias.html</xsl:with-param>
        <xsl:with-param name="tdc">index.html</xsl:with-param>
        <xsl:with-param name="nstrong">no</xsl:with-param>
        <xsl:with-param name="contenido">
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
        </xsl:with-param>
    </xsl:call-template>
    
    <xsl:call-template name="pagina">
        <xsl:with-param name="href">html/referencias.html</xsl:with-param>
        <xsl:with-param name="titulo">Referencias</xsl:with-param>
        <xsl:with-param name="anterior">terminos.html</xsl:with-param>
        <xsl:with-param name="tdc">index.html</xsl:with-param>
        <xsl:with-param name="nstrong">no</xsl:with-param>
        <xsl:with-param name="contenido">
            <xsl:apply-templates select=".//sbib">
                </xsl:apply-templates><xsl:text>
            </xsl:text> 
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>


<!-- ** Elements -->

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
    <xsl:param name="titulo"/>
    <xsl:variable name="titulosb">
        <xsl:apply-templates select="tt">
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:apply-templates select=".//sc">
        <xsl:with-param name="titulo" select="$titulosb"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="sb" mode="tdc">
    <li>
        <xsl:variable name="titulo">
            <xsl:apply-templates select="tt">
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:value-of select="$titulo"/>:
        <xsl:apply-templates select=".//sc" mode="tdc">
        </xsl:apply-templates>
    </li>
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
    <xsl:param name="titulo"/>
    <xsl:variable name="numcap" select="substring-after(./@id,'-')"/>
    <xsl:variable name="ntitle" select="concat($titulo, '. Capítulo ', $numcap)"/>
    <xsl:variable name="filename" select="concat('html/', concat(./@id, '.html'))"/>
    <xsl:variable name="psc" select="preceding-sibling::sc[position()=1]"/>
    <xsl:variable name="nsc" select="following-sibling::sc"/>
    <xsl:variable name="anterior">
        <xsl:choose>
            <xsl:when test="$psc!=''">
                <xsl:value-of select="concat($psc/@id,'.html')"/>
            </xsl:when>
            <xsl:otherwise>index.html</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="siguiente">
        <xsl:choose>
            <xsl:when test="$nsc!=''">
                <xsl:value-of select="concat($nsc/@id,'.html')"/>
            </xsl:when>
            <xsl:otherwise>index.html</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="pagina">
        <xsl:with-param name="href" select="$filename"/>
        <xsl:with-param name="titulo" select="$ntitle"/>
        <xsl:with-param name="anterior" select="$anterior"/>
        <xsl:with-param name="siguiente" select="$siguiente"/>
        <xsl:with-param name="tdc">index.html</xsl:with-param>
        <xsl:with-param name="contenido">
            <div class="chapter" id="{./@id}">
                <a name="{./@id}"/>
                <xsl:apply-templates select="cm[position()=1]">
                    <xsl:with-param name="numcap" select="$numcap"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="*[position()>1]">
                </xsl:apply-templates>
            </div>
            <hr/>
            <div class="footnotes">
                <a name="footnotes"/>
                <h3>Notas al pie</h3>
                <xsl:apply-templates mode="footnotes">
                </xsl:apply-templates>
            </div>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>


<xsl:template match="sc" mode="tdc">
    <xsl:variable name="numcap" select="substring-after(./@id,'-')"/>
    <xsl:variable name="url" select="concat(./@id, '.html')"/>
    <xsl:text> </xsl:text><a href="{$url}"><xsl:value-of select="$numcap"/></a>
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
<xsl:template match="fo|fp">
  <p class="cmPO">
    <xsl:apply-templates>
    </xsl:apply-templates>
  </p>
</xsl:template>

<xsl:template match="fo|fp" mode="footnote">
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
    <xsl:text> 
</xsl:text>
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
      <span id="t_{generate-id(key('footnote',.))}" class='texto-enlace-piedepagina'>
        <xsl:apply-templates/>
      </span> <!-- class='texto-enlace-piedepagina'-->
      <a href="#{generate-id(key('footnote',.))}" class="footnote">
        <sup class="footnote" id="s_{generate-id(key('footnote',.))}">[<xsl:value-of select="$nf2+$nf3+1"/>]</sup>
      </a>
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
                <sup class="strong"><a href="strong.html#st{$ns}" 
                        class="strong">
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
  <a href="referencias.html#bib_{./@id}">
  <xsl:value-of select="./@id"/></a>
</xsl:template>

<xsl:template match="citebib" mode="write-footnotes">
  <a href="referencias.html#bib_{./@id}">
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
    <xsl:variable name="t" select="."/>
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$t" />
      <xsl:with-param name="replace">.</xsl:with-param>
      <xsl:with-param name="by">.&#8194;</xsl:with-param>
    </xsl:call-template>
    <!-- xsl:value-of select="$t"/-->
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


