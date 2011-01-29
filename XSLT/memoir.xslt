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
				<xsl:text>\chapter*{</xsl:text>
				<xsl:apply-templates select="node()"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\chapter{</xsl:text>
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
		<xsl:text>\section{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h4">
		<xsl:text>\subsection{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h5">
		<xsl:text>\subsubsection{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h6">
		<xsl:text>{\itshape </xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- add support for Appendices - include a part or chapter named 'Appendices' to trigger-->
	
	<xsl:template match="html:h2[translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
	'abcdefghijklmnopqrstuvwxyz') = 'appendices']">
		<xsl:text>\appendixpage*
\appendix</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h1[translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
	'abcdefghijklmnopqrstuvwxyz') = 'appendices']">
		<xsl:text>\appendixpage*
\appendix</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- support for abstracts -->
	
	<xsl:template match="html:h2[1][translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
	'abcdefghijklmnopqrstuvwxyz') = 'abstract']">
		<xsl:text>\begin{abstract}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\addcontentsline{toc}{chapter}{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h2[position()='2'][preceding-sibling::html:h2[position()='1'][translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'abstract']]">
		<xsl:text>\end{abstract}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:choose>
			<xsl:when test="substring(node(), (string-length(node()) - string-length('*')) + 1) = '*'">
				<xsl:text>\chapter*{}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\chapter{</xsl:text>
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

	<xsl:template match="html:h3[count(preceding-sibling::html:h2) = '1'][preceding-sibling::html:h2[position()='1'][translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'abstract']]">
		<xsl:text>\section*{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="html:h4[count(preceding-sibling::html:h2) = '1'][preceding-sibling::html:h2[position()='1'][translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'abstract']]">
		<xsl:text>\subsection*{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- code block -->
	<xsl:template match="html:pre[child::html:code]">
		<xsl:text>\begin{adjustwidth}{2.5em}{2.5em}
\begin{verbatim}

</xsl:text>
		<xsl:value-of select="./html:code"/>
		<xsl:text>

\end{verbatim}
\end{adjustwidth}

</xsl:text>
	</xsl:template>

	<!-- no code, so treat as poetry -->
	<xsl:template match="html:pre">
		<xsl:text>\begin{adjustwidth}{4em}{4em}
\setverbatimfont{\normalfont}
\begin{verbatim}

</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>
\end{verbatim}
\end{adjustwidth}

</xsl:text>
	</xsl:template>

	
	<!-- epigraph (a blockquote immediately following a header 1-3) -->
	<xsl:template match="html:blockquote[preceding-sibling::*[1][local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h2' or local-name() = 'h3' ]]">
		<xsl:text>\epigraph{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}

</xsl:text>
	</xsl:template>

	<!-- epigraph author (a blockquote within blockquote) -->
	<xsl:template match="html:blockquote[last()][parent::*[preceding-sibling::*[1][local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h2' or local-name() = 'h3']]] ">
		<xsl:text>}{</xsl:text>
		<xsl:apply-templates select="node()"/>
	</xsl:template>

	<!-- Memoir handles glossaries differently -->

	<xsl:template match="html:li" mode="glossary">
		<xsl:param name="footnoteId"/>
		<xsl:if test="parent::html:ol/parent::html:div/@class = 'footnotes'">
			<xsl:if test="concat('#',@id) = $footnoteId">
				<xsl:apply-templates select="html:span[@class='glossary sort']" mode="glossary"/>
				<xsl:apply-templates select="html:span[@class='glossary name']" mode="glossary"/>
				<xsl:text>{</xsl:text>
				<xsl:apply-templates select="html:p" mode="glossary"/>
				<xsl:text>}</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="html:span[@class='glossary name']" mode="glossary">
		<xsl:text>{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="html:span[@class='glossary sort']" mode="glossary">
		<xsl:text>(</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>)</xsl:text>
	</xsl:template>

</xsl:stylesheet>
