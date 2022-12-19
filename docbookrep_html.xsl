<?xml version="1.0" encoding="UTF-8"?>
<!-- Extends DocBook XSL 1.56.1 -->
<!-- Extensions released to the public domain -->
<!-- http://structio.sourceforge.net/repasa -->

<!-- To use it create a XSL stylesheet to customize generation of HTML
with DocBook XSL. After importing the DocBook XSL include this one:

	<xsl:import href="/usr/local/xml/docbook-xsl/html/chunk.xsl"/>
	<xsl:include href="path_to_this_file.xsl"/>     

-->


<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version='1.0'
        xmlns="http://www.w3.org/TR/xhtml1/transitional"
	exclude-result-prefixes="#default"> 

	
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.path">./</xsl:param>

<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  nop
article   toc,title
book      toc,title,figure,table,example,equation
chapter   toc,title
part      toc,title
preface   toc,title
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
</xsl:param>


<xsl:template match="answer">
</xsl:template>

<xsl:template match="highlights">
  <xsl:choose>
    <xsl:when test="./@role='indicadores'">
        <b>Indicadores de logro</b>
    </xsl:when>
    <xsl:when test="./@role='logros'">
        <b>Logros</b>
    </xsl:when>
    <xsl:otherwise>
        <b><xsl:value-of select="./@role"/></b>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>


	<xsl:template match="para">
		<xsl:choose>
			<xsl:when test="substring(./@role,1,3)='sig' or substring(./@role,1,5)='nipal'"/>
			<xsl:otherwise>
		<xsl:call-template name="paragraph">
			<xsl:with-param name="class">
				<xsl:if test="@role and $para.propagates.style != 0">
					<xsl:value-of select="@role"/>
			</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:if test="position() = 1 and parent::listitem">
					<xsl:call-template name="anchor">
						<xsl:with-param name="node" select="parent::listitem"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="anchor"/>
				<xsl:apply-templates/>
			</xsl:with-param>
		</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- The next one is copied from html/footnote.xsl in original 
	Docbook-xsl 1.56.1 distribution -->

<xsl:template match="footnote/para[1]|footnote/simpara[1]" priority="2">
  <!-- this only works if the first thing in a footnote is a para, -->
  <!-- which is ok, because it usually is. -->
  <xsl:variable name="name">
    <xsl:text>ftn.</xsl:text>
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="ancestor::footnote"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="href">
    <xsl:text>#</xsl:text>
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="ancestor::footnote"/>
    </xsl:call-template>
  </xsl:variable>
  <p>
    <sup>
      <xsl:text>[</xsl:text>
      <a name="{$name}" href="{$href}">
        <xsl:apply-templates select="ancestor::footnote"
                             mode="footnote.number"/>
      </a>
      <xsl:text>] </xsl:text>
    </sup>
    <xsl:apply-templates/>
  </p>
</xsl:template>


</xsl:stylesheet>

