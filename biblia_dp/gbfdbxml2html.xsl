<?xml version='1.0'?>

<!-- Extension to DocBook-XSL to convert from GBF DocBook to HTML -->
<!-- Released to the public domain 2002 (vtamara@informatik.uni-kl.de) -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version='1.0'
	xmlns="http://www.w3.org/TR/xhtmll/transitional"
	exclude-result-prefixes="#default">

<xsl:import href="/usr/local/share/xml/docbook-xsl/html/docbook.xsl"/>
<!-- To generate each chapter in a different page: 
<xsl:import href="/usr/local/share/xml/docbook-xsl/html/chunk.xsl"/>
-->

<!-- Chapters are not numerated -->
<xsl:variable name="chapter.autolabel">0</xsl:variable>

<!-- No table of contents -->
<xsl:param name="generate.toc">book nop"</xsl:param>

<!-- Red, words of Jesus -->
<xsl:template match="fr">
	<b><xsl:apply-templates/></b>
</xsl:template>

</xsl:stylesheet>
