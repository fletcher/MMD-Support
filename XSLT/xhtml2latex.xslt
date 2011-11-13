<?xml version='1.0' encoding='utf-8'?>

<!-- xhtml2latex.xslt by Fletcher Penney

	Contains core routines for converting XHTML to LaTeX.
	
	Can also be called by memoir.xslt or beamer.xslt, which contain
	additional features.
	
	Requires MultiMarkdown 3.3 or greater
	
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
    xmlns:m="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="xsl"
	version="1.0">

	<xsl:import href="clean-text.xslt"/>

	<xsl:output method='text' encoding='utf-8'/>

	<xsl:strip-space elements="*" />

	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>

	<xsl:param name="footnoteId"/>

	<xsl:decimal-format name="string" NaN="1"/>

	<xsl:template match="*[local-name() = 'title']">
		<xsl:text>\def\mytitle{</xsl:text>
			<xsl:call-template name="clean-text">
				<xsl:with-param name="source">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		<xsl:text>}
</xsl:text>
	</xsl:template>

	<xsl:template match="div">
		<xsl:apply-templates select="node()"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>


	<xsl:template match="meta">
		<xsl:choose>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'latexinput'">
				<xsl:text>\input{</xsl:text>
				<xsl:value-of select="@content"/>
				<xsl:text>}
</xsl:text>
			</xsl:when>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'latexfooter'">
				<xsl:text>\input{</xsl:text>
				<xsl:value-of select="@content"/>
				<xsl:text>}
</xsl:text>
			</xsl:when>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'author'">
				<xsl:text>\def\myauthor{</xsl:text>
				<xsl:call-template name="clean-text">
					<xsl:with-param name="source">
						<xsl:value-of select="@content"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}
</xsl:text>
			</xsl:when>
		<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'date'">
			<xsl:text>\def\mydate{</xsl:text>
			<xsl:call-template name="clean-text">
				<xsl:with-param name="source">
					<xsl:value-of select="@content"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>}
</xsl:text>
		</xsl:when>
		<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'bibtex'">
				<xsl:text>\def\bibliocommand{\bibliography{</xsl:text>
				<xsl:call-template name="clean-text">
					<xsl:with-param name="source">
						<xsl:value-of select="@content"/>
					</xsl:with-param>
				</xsl:call-template>		
				<xsl:text>}}
</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\def\</xsl:text>
				<xsl:value-of select="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
				'abcdefghijklmnopqrstuvwxyz')"/>
				<xsl:text>{</xsl:text>
				<xsl:call-template name="replace-substring">
					<!-- put line breaks in -->
					<xsl:with-param name="original">
						<xsl:call-template name="clean-text">
							<xsl:with-param name="source">
								<xsl:value-of select="@content"/>
							</xsl:with-param>
						</xsl:call-template>		
					</xsl:with-param>
					<xsl:with-param name="substring">
						<xsl:text>   </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="replacement">
						<xsl:text> \\ </xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}
</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="body">
		<xsl:apply-templates select="*|comment()"/>
		<!-- <xsl:apply-templates select="*"/> 		Use this version to ignore text within XHTML comments-->
		<xsl:apply-templates select="/html/head/meta[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'latexfooter']"/>
		<xsl:text>
\end{document}
</xsl:text>
	</xsl:template>

	<xsl:template match="head">
		<!-- Init Latex -->
		<xsl:apply-templates select="*[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') != 'latexfooter']"/>
	</xsl:template>

	<!-- ignore  other information within the header 
		This will need to be expanded upon over time -->

	<xsl:template match="head/style">
	</xsl:template>

	<xsl:template match="head/base">
	</xsl:template>

	<xsl:template match="head/link">
	</xsl:template>

	<xsl:template match="head/object">
	</xsl:template>
	
	<xsl:template match="head/script">
	</xsl:template>

	<xsl:template match="text()">
		<xsl:call-template name="clean-text">
			<xsl:with-param name="source">
				<xsl:value-of select="."/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="m:*/text()">
		<xsl:call-template name="replaceEntities">
			<xsl:with-param name="content" select="normalize-space()"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Rename Bibliography -->
	<xsl:template name="rename-bibliography">
		<xsl:param name="source" />
		<xsl:text>\renewcommand\refname{</xsl:text>
		<xsl:value-of select="$source" />
		<xsl:text>}
</xsl:text>
	</xsl:template>


	<!-- paragraphs -->
	
	<xsl:template match="p">
		<xsl:apply-templates select="node()"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- last paragraph in a blockquote doesn't need extra newline -->
	<!-- needed for epigraph support -->
	<xsl:template match="p[last()][parent::*[local-name() = 'blockquote']]">
		<xsl:apply-templates select="node()"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	
	<!-- MultiMarkdown 3.0 math -->
	
	<xsl:template match="span[@class='math']">
		<xsl:choose>
			<!-- make inline math more robust -->
			<xsl:when test="starts-with(.,'\(')">
				<xsl:text>$</xsl:text>
				<xsl:value-of select="substring-before(substring-after(.,'\('),'\)')"/>
				<xsl:text>$</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- footnote li -->
	<!-- print contents of the matching footnote -->
	<xsl:template match="li" mode="footnote">
		<xsl:param name="footnoteId"/>
		<xsl:if test="parent::ol/parent::div/@class = 'footnotes'">
			<xsl:if test="concat('#',@id) = $footnoteId">
				<xsl:apply-templates select="node()"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- last paragraph in footnote does not need trailing space -->
	<xsl:template match="p[last()][parent::li[parent::ol[parent::div[@class='footnotes']]]]">
		<xsl:param name="footnoteId"/>
		<xsl:apply-templates select="node()"/>
	</xsl:template>

	<!-- print contents of the matching footnote as a glossary entry-->
	<xsl:template match="li" mode="glossary">
		<xsl:param name="footnoteId"/>
		<xsl:if test="parent::ol/parent::div/@class = 'footnotes'">
			<xsl:if test="concat('#',@id) = $footnoteId">
				<xsl:text>{</xsl:text>
				<xsl:value-of select="span[@class='glossary name']"/>
				<xsl:text>}{</xsl:text>
				<xsl:apply-templates select="span[@class='glossary sort']" mode="glossary"/>
				<xsl:apply-templates select="span[@class='glossary name']" mode="glossary"/>
				<xsl:text>description={</xsl:text>
				<xsl:apply-templates select="p" mode="glossary"/>
				<xsl:text>}}\glsadd{</xsl:text>
				<xsl:value-of select="span[@class='glossary name']"/>
				<xsl:text>}</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="p" mode="glossary">
		<xsl:apply-templates select="node()"/>
		<xsl:if test="position()!= last()">
			<xsl:text>\\
\\
</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="p[last()]" mode="glossary">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	<!-- use these when asked for -->
	<xsl:template match="span[@class='glossary name']" mode="glossary">
		<xsl:text>name={</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>},</xsl:text>
	</xsl:template>
	
	<xsl:template match="span[@class='glossary sort']" mode="glossary">
		<xsl:text>sort={</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>},</xsl:text>
	</xsl:template>

	<!-- otherwise, ignore them -->
	<xsl:template match="span[@class='glossary name']">
	</xsl:template>
	
	<xsl:template match="span[@class='glossary sort']">
	</xsl:template>

	<!-- anchors -->
	<xsl:template match="a[@href]">
		<xsl:param name="footnoteId"/>
		<xsl:choose>
			<!-- footnote (my addition)-->
			<xsl:when test="@class = 'footnote'">
				<xsl:text>\footnote{</xsl:text>
				<xsl:apply-templates select="/html/body/div[@class]/ol/li[@id]" mode="footnote">
					<xsl:with-param name="footnoteId" select="@href"/>
				</xsl:apply-templates>
				<xsl:text>}</xsl:text>
			</xsl:when>

			<xsl:when test="@class = 'footnote glossary'">
				<xsl:text>\newglossaryentry</xsl:text>
				<xsl:apply-templates select="/html/body/div[@class]/ol/li[@id]" mode="glossary">
					<xsl:with-param name="footnoteId" select="@href"/>
				</xsl:apply-templates>
				<xsl:text></xsl:text>
			</xsl:when>

			<xsl:when test="@class = 'reversefootnote'">
			</xsl:when>

			<xsl:when test="@class = 'citation'">
			<xsl:text>~\citep</xsl:text>
	        <xsl:if test="child::span[@class='locator']">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="span[@class='locator']"/>
				<xsl:text>]</xsl:text>
			</xsl:if>
			<xsl:text>{</xsl:text>
			<xsl:value-of select="span[@class='citekey']"/>
			<xsl:text>}</xsl:text>
			</xsl:when>
			
			<!-- if href is same as the anchor text, then use \href{} 
				but no footnote -->
			<xsl:when test="@href = .">
				<xsl:text>\href{</xsl:text>
				<xsl:value-of select="@href"/>
				<xsl:text>}{</xsl:text>
				<xsl:call-template name="clean-text">
					<xsl:with-param name="source">
						<xsl:value-of select="@href"/>
					</xsl:with-param>
				</xsl:call-template>		
				<xsl:text>}</xsl:text>
			</xsl:when>

			<!-- if href is mailto, use \href{} -->
			<xsl:when test="starts-with(@href,'mailto:')">
				<xsl:text>\href{</xsl:text>
				<xsl:value-of select="@href"/>
				<xsl:text>}{</xsl:text>
				<xsl:call-template name="clean-text">
					<xsl:with-param name="source">
						<xsl:value-of select="substring-after(@href,'mailto:')"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}</xsl:text>
			</xsl:when>
			
			<!-- if href is local anchor, use autoref -->
			<xsl:when test="starts-with(@href,'#')">
				<xsl:choose>
					<xsl:when test=". = ''">
						<xsl:text>\autoref{</xsl:text>
						<xsl:call-template name="lower-case">
							<xsl:with-param name="source">
								<xsl:value-of select="substring-after(@href,'#')"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>}</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="clean-text">
							<xsl:with-param name="source">
								<xsl:value-of select="."/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text> (\autoref{</xsl:text>
						<xsl:value-of select="substring-after(@href,'#')"/>
						<xsl:text>})</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<!-- otherwise, implement an href and put href in footnote
				for printed version -->
			<xsl:otherwise>
				<xsl:text>\href{</xsl:text>
				<xsl:value-of select="@href"/>
				<xsl:text>}{</xsl:text>
				<xsl:call-template name="clean-text">
					<xsl:with-param name="source">
						<xsl:value-of select="."/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}</xsl:text>
				<xsl:choose>
					<xsl:when test="parent::*[local-name() = 'h1']"/>
					<xsl:when test="parent::*[local-name() = 'h2']"/>
					<xsl:when test="parent::*[local-name() = 'h3']"/>
					<xsl:when test="parent::*[local-name() = 'h4']"/>
					<xsl:when test="parent::*[local-name() = 'h5']"/>
					<xsl:when test="parent::*[local-name() = 'h6']"/>
					<xsl:otherwise>
						<xsl:text>\footnote{\href{</xsl:text>
						<xsl:value-of select="@href"/>
						<xsl:text>}{</xsl:text>
						<xsl:call-template name="clean-text">
							<xsl:with-param name="source">
								<xsl:value-of select="@href"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>}}</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ordered list -->
	<xsl:template match="ol">
		<xsl:text>\begin{enumerate}
</xsl:text>
		<xsl:apply-templates select="*"/>
		<xsl:text>\end{enumerate}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- unordered list -->
	<xsl:template match="ul">
		<xsl:text>\begin{itemize}
</xsl:text>
		<xsl:apply-templates select="*"/>
		<xsl:text>\end{itemize}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	
	<!-- list item -->
	<xsl:template match="li[child::p]">
		<xsl:text>\item </xsl:text>
		<xsl:apply-templates select="node()"/>
	</xsl:template>

	<xsl:template match="li">
		<xsl:text>\item </xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- definition list - fake it for compatibility with XHTML version -->
    <xsl:template match="dl">
	<xsl:text>\begin{description}

</xsl:text>
<xsl:apply-templates select="node()"/>
        <xsl:text>\end{description}

</xsl:text>
    </xsl:template>

    <xsl:template match="dt">
        <xsl:text>\item[</xsl:text>
        <xsl:apply-templates select="node()"/>
        <xsl:text>]

</xsl:text>
    </xsl:template>

    <xsl:template match="dd">
        <xsl:apply-templates select="node()"/>
        <xsl:if test="not(child::p)">
	<xsl:text>

</xsl:text>
		</xsl:if>
    </xsl:template>

	<!-- code block -->
	<xsl:template match="pre[child::code]">
		<xsl:text>\begin{verbatim}

</xsl:text>
		<xsl:value-of select="./code"/>
		<xsl:text>
\end{verbatim}


</xsl:text>
	</xsl:template>

	<!-- code span -->
	<xsl:template match="code">
		<xsl:text>\texttt{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<!-- line ending -->
	<xsl:template match="br">
		<xsl:text>\\</xsl:text>
	</xsl:template>

	<!-- blockquote -->
	<xsl:template match="blockquote">
		<xsl:text>\begin{quote}

</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>\end{quote}

</xsl:text>
	</xsl:template>

	<!-- emphasis -->
	<xsl:template match="em">
		<xsl:text>\emph{</xsl:text>
			<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<!-- strong -->
	<xsl:template match="strong">
		<xsl:text>\textbf{</xsl:text>
			<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<!-- horizontal rule -->
	<xsl:template match="hr">
		<xsl:text>\vskip 2em
\hrule height 0.4pt
\vskip 2em

</xsl:text>
	</xsl:template>

	<!-- images -->
	
	<xsl:template match="figure">
		<xsl:text>\begin{figure}[htbp]
</xsl:text>
		<xsl:text>\centering
</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:if test="descendant::img/@id">
			<xsl:text>\label{</xsl:text>
			<xsl:value-of select="descendant::img/@id"/>
			<xsl:text>}
</xsl:text>
		</xsl:if>
		<xsl:text>\end{figure}
</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	
	<xsl:template match="figcaption">
		<xsl:text>\caption{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}
</xsl:text>
	</xsl:template>

	<xsl:template match="img">
		<xsl:text>\includegraphics[</xsl:text>
		
		<xsl:variable name="wReverse">
			<xsl:call-template name="reverse">
				<xsl:with-param name="pString"
					select="concat(';',@style,';')"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="wAfter">
			<xsl:call-template name="reverse">
				<xsl:with-param name="pString"
					select="substring-before($wReverse,':htdiw;')"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="width">
			<xsl:value-of select="substring-before($wAfter,';')"/>
		</xsl:variable>
		
		<xsl:variable name="hReverse">
			<xsl:call-template name="reverse">
				<xsl:with-param name="pString"
					select="concat(';',@style,';')"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hAfter">
			<xsl:call-template name="reverse">
				<xsl:with-param name="pString"
					select="substring-before($hReverse,':thgieh;')"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="height">
			<xsl:value-of select="substring-before($hAfter,';')"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="($width != '') and ($height != '')">
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>keepaspectratio,</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="($width != '' ) or ($height != '')">
			<!-- there are dimensions, so use them -->
			<!-- Basically, we allow any units covered by LaTeX, even
				if they are not allowed in XHTML.  px is converted to pt.
				If no units, then assume pt.
			-->
			<xsl:text>width=</xsl:text>
			<xsl:choose>
				<xsl:when test="$width != ''">
					<xsl:call-template name="replace-substring">
						<xsl:with-param name="original">
							<xsl:value-of select="$width"/>
						</xsl:with-param>
						<xsl:with-param name="substring">
							<xsl:text>px</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="replacement">
							<xsl:text>pt</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:if test="translate($width, 
	'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.'
	,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') = '' ">
						<!-- no units specified -->
						<xsl:text>pt</xsl:text>
					</xsl:if>
				</xsl:when> 
				<xsl:otherwise>
					<xsl:text>\textwidth</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,height=</xsl:text>
			<xsl:choose>
				<xsl:when test="$height != ''">
					<xsl:call-template name="replace-substring">
						<xsl:with-param name="original">
							<xsl:value-of select="$height"/>
						</xsl:with-param>
						<xsl:with-param name="substring">
							<xsl:text>px</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="replacement">
							<xsl:text>pt</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:if test="translate($height, 
	'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.'
	,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') = '' ">
						<!-- no units specified -->
						<xsl:text>pt</xsl:text>
					</xsl:if>
				</xsl:when> 
				<xsl:otherwise>
					<xsl:text>0.75\textheight</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>]</xsl:text>
		</xsl:if>
		<xsl:if test="not(($width != '') or ($height != ''))">
			<!-- if no dimensions, then ensure it fits on page
				(of course, this also goes to "max zoom"...)
			 -->
			 <xsl:text>width=\textwidth,height=0.75\textheight]</xsl:text>
		</xsl:if>
		<xsl:text>{</xsl:text>
		<xsl:value-of select="@src"/>
		<xsl:text>}
</xsl:text>
	</xsl:template>
	
	<!-- footnotes -->
	<xsl:template match="div">
		<xsl:if test="not(@class = 'footnotes')">
			<xsl:apply-templates select="node()"/>
		</xsl:if>
	</xsl:template>

	<!-- pull-quotes (a table with no header, and a single column) -->
	<!-- this is experimental, and I am open to suggestions -->
	<xsl:template match="table[@class='pull-quote']">
		<xsl:text>\begin{table}[htbp]
\begin{minipage}{\linewidth}
\centering
</xsl:text>
		<xsl:apply-templates select="caption"/>
		<xsl:text>\begin{tabulary}{\textwidth}{@{}p{0.5\linewidth}@{}} \toprule </xsl:text>
		<xsl:apply-templates select="thead"/>
		<xsl:apply-templates select="tbody"/>
		<xsl:apply-templates select="tr"/>
		<xsl:text>\end{tabulary}
\end{minipage}
\end{table}


</xsl:text>
	</xsl:template>

	<!-- tables -->
	<xsl:template match="table">
		<xsl:text>\begin{table}[htbp]
\begin{minipage}{\linewidth}
\setlength{\tymax}{0.5\linewidth}
\centering
\small
</xsl:text>
		<xsl:apply-templates select="caption"/>
		<xsl:text>\begin{tabulary}{\textwidth}{@{}</xsl:text>
		<xsl:apply-templates select="colgroup/col"/>
		<xsl:text>@{}} \toprule</xsl:text>
		<xsl:apply-templates select="thead"/>
		<xsl:apply-templates select="tbody"/>
		<xsl:apply-templates select="tr"/>
		<xsl:text>\end{tabulary}
\end{minipage}
\end{table}


</xsl:text>
	</xsl:template>
	
	<xsl:template match="tbody[last()]">
		<xsl:apply-templates select="tr"/>
\bottomrule

</xsl:template>

	<xsl:template match="tbody">
		<xsl:apply-templates select="tr"/>
\midrule
</xsl:template>

	<xsl:template match="col">
		<xsl:choose>
			<xsl:when test="@style='text-align:center;'">
				<xsl:choose>
					<xsl:when test="@class='extended'">
						<xsl:text>C</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>c</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@style='text-align:right;'">
				<xsl:choose>
					<xsl:when test="@class='extended'">
						<xsl:text>R</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>r</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@class='extended'">
						<xsl:text>L</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>l</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="thead">
		<xsl:apply-templates select="tr" mode="header"/>
		<xsl:text>
\midrule
</xsl:text>
	</xsl:template>
	
	<xsl:template match="caption">
		<xsl:text>\caption{</xsl:text>
			<xsl:apply-templates select="node()"/>
		<xsl:text>}
</xsl:text>
		<xsl:if test="@id">
			<xsl:text>\label{</xsl:text>
			<xsl:value-of select="@id"/>
			<xsl:text>}
</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="tr" mode="header">
		<xsl:text>
</xsl:text>
		<xsl:apply-templates select="td|th"/>
		<xsl:text>\\</xsl:text>
		<!-- figure out a way to count columns for \cmidrule{x-y} -->
		<xsl:apply-templates select="td[1]|th[1]" mode="scmidrule">
			<xsl:with-param name="col" select="1"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="td|th" mode="cmidrule">
		<xsl:param name="col"/>
		<xsl:param name="end" select="$col+format-number(@colspan,'#','string')-1"/>
		<xsl:if test="not(. = '')">
			<xsl:text> \cmidrule{</xsl:text>
			<xsl:value-of select="$col"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$end"/>
			<xsl:text>}</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="following-sibling::*[1]" mode="cmidrule">
			<xsl:with-param name="col" select="$end+1"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="tr[last()]" mode="header">
		<xsl:text>
</xsl:text>
		<xsl:apply-templates select="td|th"/>
		<xsl:text>\\</xsl:text>
	</xsl:template>

	<xsl:template match="tr">
		<xsl:apply-templates select="td|th"/>
		<xsl:text>\\
</xsl:text>
	</xsl:template>

	<xsl:template match="th|td">
		<xsl:if test="@colspan">
			<xsl:text>\multicolumn{</xsl:text>
			<xsl:value-of select="@colspan"/>
		</xsl:if>
		<xsl:if test="@colspan">
			<xsl:text>}{c}{</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="node()"/>
		<xsl:if test="@colspan">
			<xsl:text>}</xsl:text>
		</xsl:if>
		<xsl:if test="position()!=last()">
    		<xsl:text>&amp;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- Support for Bibliography to BibTeX conversion -->
	
	<xsl:template match="span[@class='externalcitation']">
		<xsl:text>~\citep</xsl:text>
		<xsl:if test="not(starts-with(.,'[#'))">
			<xsl:value-of select="substring-before(.,'[#')"/>
		</xsl:if>
		<xsl:text>{</xsl:text>
		<xsl:value-of select="substring-before(substring-after(.,'#'),']')"/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="span[@class='citation']">
		<xsl:text>~\citep</xsl:text>
		<xsl:apply-templates select="span" mode="citation"/>
		<xsl:apply-templates select="a" mode="markdowncitation"/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="span[@class='notcited']">
		<xsl:text>~\nocite{</xsl:text>
		<xsl:value-of select="span[@class='citekey']"/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="a[@id]" mode="citation">
		<xsl:text>{</xsl:text>
		<xsl:value-of select="@id"/>
	</xsl:template>

	<xsl:template match="a[@href]" mode="markdowncitation">
		<xsl:text>{</xsl:text>
		<xsl:value-of select="substring-after(@href,'#')"/>
	</xsl:template>

	<xsl:template match="span[@class='locator']" mode="citation">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<!-- Disabled unless natbib is implemented -->
	<xsl:template match="span[@class='textual citation']" mode="citation">
		<xsl:text></xsl:text>
	</xsl:template>
	
	<xsl:template match="div[@class='footnotes'][descendant::li[@class='citation']]">
		<xsl:text>\begin{thebibliography}{</xsl:text>
		<xsl:value-of select="count(div[@id])"/>
		<xsl:text>}
</xsl:text>
		<xsl:apply-templates select="ol/li[@class='citation']"/>
		<xsl:text>
\end{thebibliography}

</xsl:text>
	</xsl:template>
				
	<xsl:template match="li[@class='citation']">
		<xsl:text>
\bibitem{</xsl:text>
		<xsl:value-of select="descendant::span[@class='citekey']"/>
		<xsl:text>}
</xsl:text>
		<xsl:apply-templates select="p"/>
		<xsl:text>

</xsl:text>
	</xsl:template>

	<xsl:template match="span[@class='item']" mode="citation">
		<xsl:apply-templates select="."/>
	</xsl:template>
	

	<!-- Allow for spans to set a color 
		Specifically, this is useful with Scrivener -->
	<xsl:template match="span[starts-with(@style,'color:')]">
		<xsl:text>{\color[HTML]{</xsl:text>
		<xsl:call-template name="replace-substring">
			<xsl:with-param name="original">
				<xsl:value-of select="@style"/>
			</xsl:with-param>
			<xsl:with-param name="substring">
				<xsl:text>color:#</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="replacement">
				<xsl:text></xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>} </xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<!-- replace-substring routine by Doug Tidwell - XSLT, O'Reilly Media -->
	<xsl:template name="replace-substring">
		<xsl:param name="original" />
		<xsl:param name="substring" />
		<xsl:param name="replacement" select="''"/>
		<xsl:variable name="first">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)" >
					<xsl:value-of select="substring-before($original, $substring)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$original"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="middle">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)" >
					<xsl:value-of select="$replacement"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="last">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)">
					<xsl:choose>
						<xsl:when test="contains(substring-after($original, $substring), $substring)">
							<xsl:call-template name="replace-substring">
								<xsl:with-param name="original">
									<xsl:value-of select="substring-after($original, $substring)" />
								</xsl:with-param>
								<xsl:with-param name="substring">
									<xsl:value-of select="$substring" />
								</xsl:with-param>
								<xsl:with-param name="replacement">
									<xsl:value-of select="$replacement" />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>	
						<xsl:otherwise>
							<xsl:value-of select="substring-after($original, $substring)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>		
			</xsl:choose>				
		</xsl:variable>		
		<xsl:value-of select="concat($first, $middle, $last)"/>
	</xsl:template>	

	<!-- Convert headers into chapters, etc -->
	
	<xsl:template match="h1">
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

	<xsl:template match="h2">
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

	<xsl:template match="h3">
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

	<xsl:template match="h4">
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

	<xsl:template match="h5">
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

	<xsl:template match="h6">
		<xsl:text>\paragraph{</xsl:text>
		<xsl:apply-templates select="node()"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:text>\label{</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="*[@class='noxslt']">
	</xsl:template>
	
	<!-- Utility function to assist with parsing @style attributes.  From
		http://stackoverflow.com/questions/5050491/ need-to-take-recent-style-from-html-tag-through-xslt
	
	-->
	<xsl:template name="reverse">
        <xsl:param name="pString"/>
        <xsl:if test="$pString">
            <xsl:call-template name="reverse">
                <xsl:with-param name="pString" select="substring($pString,2)"/>
            </xsl:call-template>
            <xsl:value-of select="substring($pString,1,1)"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
