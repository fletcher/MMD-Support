<?xml version='1.0' encoding='utf-8'?>

<!-- beamer.xslt by Fletcher Penney

	Adds features to xhtml2latex.xslt that are designed to take advantage
	of LaTeX features within the beamer class. 
	
	Requires MultiMarkdown 3.0 or greater
	
-->

<!-- 
# Copyright (C) 2011  Fletcher T. Penney <fletcher@fletcherpenney.net>
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

	<xsl:template match="html:body">
		<body>
			<xsl:apply-templates select="html:h1|html:h2|html:h3|html:h4|html:h5|html:h6"/>
			<xsl:apply-templates select="/html:html/html:head/html:meta[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'latexfooter']"/>
		</body>
	</xsl:template>

	<xsl:template match="html:div[@class='footnotes'][descendant::html:li[@class='citation']]">
		<xsl:text>\end{frame}

\part{Bibliography}
\begin{frame}[allowframebreaks]
\frametitle{Bibliography}
\def\newblock{}
\begin{thebibliography}{</xsl:text>
		<xsl:value-of select="count(div[@id])"/>
		<xsl:text>}</xsl:text>
		<xsl:apply-templates select="html:ol/html:li[@class='citation']"/>
		<xsl:text>
\end{thebibliography}
</xsl:text>
	</xsl:template>

	<!-- Rename Bibliography -->
	<xsl:template name="rename-bibliography">
		<xsl:param name="source" />
		<xsl:text>\renewcommand\bibname{</xsl:text>
		<xsl:value-of select="$source" />
		<xsl:text>}
</xsl:text>
	</xsl:template>

	<!-- Convert headers into chapters, etc -->
	
	<xsl:template match="html:h1">
		<xsl:choose>
			<xsl:when test="substring(node(), (string-length(node()) - string-length('*')) + 1) = '*'">
				<xsl:text>\part*{}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\part{</xsl:text>
				<xsl:apply-templates select="node()"/>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h2">
		<xsl:choose>
			<xsl:when test="substring(node(), (string-length(node()) - string-length('*')) + 1) = '*'">
				<xsl:text>\section*{</xsl:text>
				<xsl:apply-templates select="node()"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\section{</xsl:text>
				<xsl:apply-templates select="node()"/>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h3">
		<xsl:text>\begin{frame}</xsl:text>
		<xsl:variable name="children" select="count(following-sibling::*) - count(following-sibling::*[local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h3' or local-name() = 'h4' or local-name() = 'h5' or local-name() = 'h6'][1]/following-sibling::*) - count(following-sibling::*[local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h3' or local-name() = 'h4' or local-name() = 'h5' or local-name() = 'h6'][1])"/>
		<xsl:if test="count(following-sibling::*[position() &lt;= $children][local-name() = 'pre']) &gt; 0">
			<xsl:text>[fragile]</xsl:text>
		</xsl:if>
		<xsl:text>

\frametitle{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>

		<xsl:apply-templates select="following-sibling::*[position() &lt;= $children]"/>
		<xsl:text>\end{frame}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h4">
		<xsl:text>\mode&lt;article>{</xsl:text>
		<xsl:variable name="children" select="count(following-sibling::*) - count(following-sibling::*[local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h3' or local-name() = 'h4' or local-name() = 'h5' or local-name() = 'h6'][1]/following-sibling::*) - count(following-sibling::*[local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h3' or local-name() = 'h4' or local-name() = 'h5' or local-name() = 'h6'][1])"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="following-sibling::*[position() &lt;= $children]"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h5|html:h6">
		<xsl:text>\emph{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:meta[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
	'abcdefghijklmnopqrstuvwxyz') = 'latexfooter']">
		<xsl:text>\mode&lt;all>
\input{</xsl:text>
		<xsl:call-template name="clean-text">
			<xsl:with-param name="source">
				<xsl:value-of select="@content"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>}

\end{document}\mode*

</xsl:text>
	</xsl:template>

	<xsl:template match="*[@class='noxslt']">
	</xsl:template>

</xsl:stylesheet>
