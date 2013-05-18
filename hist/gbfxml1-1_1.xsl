<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- XSL to convert from GBF XML 1.0 to 1.1 -->
<!-- Source released to the public domain 2005.
     No warranties.
     vtamara@pasosdejesus.org -->


     <!--
     Arreglos sugeridos antes de pasarlo:

     <pp><cm>
     </cm>
	     a 
     <pp>	    
	
     <cm>
     </cm>
     </sc>
	    a
    </sc>	    
	     Falta:
     Problema con cm, pp y sv:
     <cm>
	     <sv x>..
	     <pp>
		     <cm>
			     <sv y> 1
		     </cm>
		     <cm>
			2
		     </cm>
		...
	     </pp>
     </cm>

     Debería quedar
     <cm>
	     <sv x>
		     ...
	     </sv>
     </cm>
     <cm type=PO>
     <sv y>1
       <cl/>
       2
       ...
     </sv>
     </cm type=PO>
     -->
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="ISO-8859-1"/>

<!-- Entry point -->
<xsl:template match="gbfxml">
<gbfxml version="1.1" lang="{./@lang}">
	<xsl:apply-templates>
	</xsl:apply-templates>
</gbfxml>
</xsl:template>

<!-- Long title -->
<xsl:template match="tt"> 
<tt><xsl:apply-templates/></tt>
</xsl:template>

<!-- Short title -->
<xsl:template match="stt"> 
<stt><xsl:apply-templates/></stt>
</xsl:template>

<!-- Short copyright notice -->
<xsl:template match="sumrights"> 
<sumrights lang="{./@lang}"><xsl:apply-templates/></sumrights>
</xsl:template>

<!-- Long copyright notice -->
<xsl:template match="rights"> 
<rights lang="{./@lang}"><xsl:apply-templates/></rights>
</xsl:template>

<!-- Table of contents -->
<xsl:template match="toc"> 
<toc><xsl:apply-templates/></toc>
</xsl:template>



<!-- Book --> 
<xsl:template match="sb">
<sb id="{./@id}" type="{./@type}" lang="{./@lang}">
	<xsl:apply-templates/>
</sb>
</xsl:template>


<!-- Chapter -->
<xsl:template match="sc">
<sc id="{./@id}">
	<xsl:apply-templates/>
	<xsl:text disable-output-escaping="yes">&lt;/sv&gt;</xsl:text>
	<xsl:text disable-output-escaping="yes">&lt;/cm&gt;</xsl:text>
</sc>
</xsl:template>

<!-- Paragraph of chapter.  -->
<xsl:template match="cm">
	<xsl:param name="pp"/>
	<xsl:variable name="nsv">
		<xsl:apply-templates select="./sv"/> 
		<xsl:value-of select="child::fr[child::sv]"/>
	</xsl:variable>

	<xsl:variable name="n1">
		<xsl:value-of select="normalize-space(node()[1])"/>
	</xsl:variable>

	<xsl:variable name="t1">
		<xsl:value-of select="normalize-space(child::text()[position()=1])"/>
	</xsl:variable>

	<xsl:variable name="fr1">
		<xsl:apply-templates select="fr[position()=1]"/>
	</xsl:variable> 

	<!--position es '<xsl:value-of select="position()"/>'
	pp es '<xsl:value-of select="$pp"/>'
	nsv es '<xsl:value-of select="$nsv"/>'
	n1 es '<xsl:value-of select="$n1"/>'
	t1 es '<xsl:value-of select="$t1"/>'
	fr1 es '<xsl:value-of select="normalize-space($fr1)"/>'    -->

	<xsl:if test="$pp != '' or position()>2">
		<xsl:if test="$nsv != ''  and ($t1 = '' or $n1 = '')">
			<xsl:text disable-output-escaping="yes">&lt;/sv&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;/cm&gt;</xsl:text>
		</xsl:if>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="$t1 != '' and $n1 != ''">
			<xsl:text disable-output-escaping="yes">&lt;cl/&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="$t1 != '' and $n1 != '' and $fr1 != ''">
			<xsl:text disable-output-escaping="yes">&lt;cl/&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="$nsv = '' and $t1 = '' and $fr1 = ''">
			<xsl:text disable-output-escaping="yes">&lt;cl/&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="$pp = ''">
			<xsl:text disable-output-escaping="yes">&lt;cm&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="$pp != '' and $nsv = ''">
		</xsl:when>

		<xsl:otherwise>  
			<xsl:text disable-output-escaping="yes">&lt;cm type="PO"&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>

	<xsl:if test="$pp != '' and $nsv = ''">
		<xsl:text disable-output-escaping="yes">&lt;fp&gt;</xsl:text>
	</xsl:if>

	<xsl:apply-templates>
		<!--		<xsl:with-param name="pp" select="$pp"/> -->
	</xsl:apply-templates>

	
	<!--cm2 pp es '<xsl:value-of select="$pp"/>'
	cm2 nsv es '<xsl:value-of select="$nsv"/>'
	position es '<xsl:value-of select="position()"/>' -->
	<xsl:if test="$pp != '' and $nsv = '' and position() &lt;= 2">
		<xsl:text disable-output-escaping="yes">&lt;/fp&gt;</xsl:text>
	</xsl:if>


	<!--	<xsl:if test="$t1 != '' and $pp != ''">
		<xsl:text disable-output-escaping="yes">&lt;/fp&gt;</xsl:text>
	</xsl:if> -->
	<!--	<xsl:if  test="$nsv != ''"> 
		<xsl:text disable-output-escaping="yes">&lt;/sv&gt;</xsl:text>
	</xsl:if>
	<xsl:if test="$pp != ''">
		position() es <xsl:value-of select="position()"/>
		last() es <xsl:value-of select="last()"/>
		<xsl:text disable-output-escaping="yes">&lt;cm type="PO"&gt;</xsl:text>
	</xsl:if> -->
</xsl:template>


<!-- Strong style -->
<xsl:template match="fb">
	<fb><xsl:apply-templates/></fb>
</xsl:template>

<!-- Small Caps -->
<xsl:template match="fc">
	<fc><xsl:apply-templates/></fc>
</xsl:template>

<!-- Words of Jesus -->
<xsl:template match="fr">
	<xsl:variable name="nsv">
		<xsl:value-of select="count(descendant::sv)"/>
	</xsl:variable>
	<xsl:variable name="nt">
		<xsl:value-of select="normalize-space(text()[position()=1])"/>
	</xsl:variable>
	<!-- fr.  nsv es '<xsl:value-of select="$nsv"/>'
	nt es '<xsl:value-of select="$nt"/>' -->
	<xsl:choose>
		<xsl:when  test="$nsv = 0"> 
			<fr><xsl:apply-templates/></fr>
		</xsl:when>
		<xsl:otherwise> 
			<xsl:if test="$nt != ''">
				<xsl:text disable-output-escaping="yes">&lt;fr&gt;</xsl:text>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="fr" select="$nsv"/>
			</xsl:apply-templates>
			<xsl:text disable-output-escaping="yes">&lt;/fr&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Superscript -->
<xsl:template match="fs">
	<fs><xsl:apply-templates/></fs>
</xsl:template>

<!-- Underline -->
<xsl:template match="fu">
	<fu><xsl:apply-templates/></fu>
</xsl:template>

<!-- Subscript -->
<xsl:template match="fv">
	<fv><xsl:apply-templates/></fv>
</xsl:template>

<!-- Break line -->
<xsl:template match="cl">
	<cl/>
</xsl:template>

<!-- Poetry -->
<xsl:template match="pp">

	<xsl:variable name="ncm">
		<xsl:apply-templates select="./cm"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when  test="$ncm = ''">
			<fp><xsl:apply-templates>
				<xsl:with-param name="pp" select="."/>
			</xsl:apply-templates>
			</fp>
		</xsl:when>
		<xsl:otherwise>
			<!--			<xsl:if test="position()>2">
				<xsl:text disable-output-escaping="yes">&lt;/sv>&lt;/cm> 
</xsl:text>
			</xsl:if>-->
			<xsl:apply-templates>
				<xsl:with-param name="pp" select="."/>
			</xsl:apply-templates>
			<!--			<xsl:text disable-output-escaping="yes">&lt;/cm>
			</xsl:text> -->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Verse -->

<xsl:template name="psv">
<xsl:text disable-output-escaping="yes">&lt;sv id="</xsl:text><xsl:value-of select="./@id"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
</xsl:template>

<xsl:template match="sv">
	<xsl:param name="fr"/>
	<xsl:param name="pp"/>
	<xsl:if test="position()>2 or $fr != ''">
		<xsl:if test="$fr != ''">
			<xsl:text disable-output-escaping="yes">&lt;/fr>
			</xsl:text>
		</xsl:if>
		<xsl:if test="$pp != ''">
			<xsl:text disable-output-escaping="yes">&lt;/fp></xsl:text>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;/sv>
		</xsl:text>
	</xsl:if>
	<xsl:call-template name="psv"/>
	<xsl:if test="$pp != ''">
		<xsl:text disable-output-escaping="yes">&lt;fp></xsl:text>
	</xsl:if>
	<xsl:if test="$fr != ''">
		<xsl:text disable-output-escaping="yes">&lt;fr&gt;</xsl:text>
	</xsl:if>
</xsl:template>


<!-- Text with embedded footnote  --> 
<xsl:template match="rb">
	<xsl:choose>
		<xsl:when test="./@lang != ''">
			<rb lang="{./@lang}"><xsl:apply-templates/></rb>
		</xsl:when>
		<xsl:otherwise>
			<rb><xsl:apply-templates/></rb>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Footnote -->
<xsl:template match="rf">
	<rf><xsl:apply-templates/></rf>
</xsl:template>

<!-- Word information -->
<xsl:template match="wi">
	<xsl:variable name="val"><xsl:value-of select="."/></xsl:variable>
	<wi type="{./@type}" value="{$val}"/>
</xsl:template>

<!-- Parallel passage -->
<xsl:template match="rp">
	<xsl:text>OJO rp</xsl:text>
</xsl:template>

<!-- Cross reference -->
<xsl:template match="rx">
	<xsl:text>OJO rx</xsl:text>
</xsl:template>

<!-- Cite to bibliography -->
<xsl:template match="citebib">
	<citebib id="{./@id}"/>
</xsl:template>

<!-- Translation -->
<xsl:template match="t">
	<t lang="{./@lang}"><xsl:apply-templates/></t>
</xsl:template>

<!-- Section of bibliography -->
<xsl:template match="sbib">
<sbib>
	<xsl:apply-templates/>
</sbib>
</xsl:template>

<xsl:template match="bib">
<sbib>
	<xsl:apply-templates/>
</sbib>
</xsl:template>

<xsl:template match="author">
	<author><xsl:apply-templates/></author>
</xsl:template>

<xsl:template match="editor">
	<editor><xsl:apply-templates/></editor>
</xsl:template>

<xsl:template match="otherbib">
	<otherbib><xsl:apply-templates/></otherbib>
</xsl:template>

<xsl:template match="st">
	<xsl:variable name="vn"><xsl:value-of select="./@n"/><xsl:value-of select="./@c"/></xsl:variable>
	<wi type="G" value="{$vn},,"><xsl:apply-templates/></wi>
</xsl:template>

<xsl:template match="url">
	<url><xsl:apply-templates/></url>
</xsl:template>

<xsl:template match="credits">
	<credits version="{./@version}" lang="{./@lang}"><xsl:apply-templates/></credits>
</xsl:template>



<!-- Text -->
<xsl:template match="text()">
	<xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>

<xsl:template match="comment()">
	<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text><xsl:value-of disable-output-escaping="yes" select="."/> <xsl:text disable-output-escaping="yes">--&gt;
</xsl:text>
</xsl:template>

</xsl:stylesheet>


