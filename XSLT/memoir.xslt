<?xml version='1.0' encoding='utf-8'?>

<!-- memoir.xslt by Fletcher Penney

	Adds features to xhtml2latex.xslt that are designed to take advantage
	of LaTeX features within the memoir class. 
	
	Requires MultiMarkdown 3.0 or greater
	
-->

<!-- 
# Copyright (C) 2005-2011  Fletcher T. Penney <fletcher@fletcherpenney.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the
#    Free Software Foundation, Inc.
#    59 Temple Place, Suite 330
#    Boston, MA 02111-1307 USA
-->


<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	version="1.0">

	<xsl:import href="xhtml2latex.xslt"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="html:html/html:head"/>
		<xsl:apply-templates select="html:html/html:body"/>
	</xsl:template>

	<!-- Rename Bibliography -->
	<xsl:template name="rename-bibliography">
		<xsl:param name="source" />
		<xsl:text>\renewcommand\bibname{</xsl:text>
		<xsl:value-of select="$source" />
		<xsl:text>}
</xsl:text>
	</xsl:template>

	<!-- code block that is not a child element -->
	<xsl:template match="html:pre[child::html:code][parent::html:body]">
		<xsl:text>\begin{adjustwidth}{2.5em}{2.5em}
\begin{verbatim}

</xsl:text>
		<xsl:value-of select="./html:code"/>
		<xsl:text>
\end{verbatim}
\end{adjustwidth}

</xsl:text>
	</xsl:template>

	<xsl:template match="*[@class='noxslt']">
	</xsl:template>

</xsl:stylesheet>
