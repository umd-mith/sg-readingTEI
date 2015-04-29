<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs"
  version="2.0">
  
<!-- 
  add: passes through without copying
  del: dropped
  mod: passes through without copying
  add/ptr: resolved (target contents copied in)
  
  addSpan, modSpan : dropped
  delSpan: dropped
    also removes all text after a delSpan up to its anchor (indicated by the delSpan/@spanTo)

  -->
 
  <!-- TODO: deal with listTranspose and relater tei:seg. Used for listTranspose *across lines* in c56 38 --> 
 
  <xsl:strip-space elements="mod"/>
  
  <xsl:template match="* | @*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="add | mod">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="del"/>
  
  <xsl:template match="addSpan | delSpan | modSpan | mod[@spanTo] | 
                       milestone[@unit='tei:seg'] | listTranspose "/>
  
  <xsl:template match="anchor">
    <xsl:choose>
      <xsl:when test="concat('#', @xml:id) = (//addSpan/@spanTo, //delSpan/@spanTo, 
                                              //modSpan/@spanTo, //mod/@spanTo,
                                              //milestone[@unit='tei:seg']/@spanTo)"/>
      <xsl:when test="not(concat('#', @xml:id) = //*/@spanTo)"/>
      <xsl:otherwise>
        <xsl:sequence select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:key name="delSpan-for-text" match="delSpan">
    <xsl:apply-templates select="following::node()[1]" mode="collect-delSpan">
      <xsl:with-param name="delSpanTo" tunnel="yes" select="replace(@spanTo,'^#','')"/>
    </xsl:apply-templates>
  </xsl:key>
  
  <xsl:template match="node()" mode="collect-delSpan">
    <xsl:apply-templates select="(descendant::node() | following::node())[1]" 
      mode="collect-delSpan" />
  </xsl:template>
  
  <xsl:template match="anchor" mode="collect-delSpan">
    <xsl:param name="delSpanTo" required="yes" tunnel="yes"/>
    <xsl:if test="@xml:id ne $delSpanTo">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="text()" mode="collect-delSpan" priority="1">
    <xsl:sequence select="generate-id()"/>
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="milestone | anchor" mode="collect-delSpan" priority="1">
    <xsl:sequence select="generate-id()"/>
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:if test="empty(key('delSpan-for-text',generate-id()))">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="milestone[not(@unit='tei:seg')]">
    <xsl:if test="empty(key('delSpan-for-text',generate-id()))">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="anchor[not(//zone[@corresp=concat('#', current()/@xml:id)])]">
    <xsl:if test="empty(key('delSpan-for-text',generate-id()))">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="ptr">
    <add source="{@target}">
      <xsl:apply-templates select="id(replace(@target,'^#',''))" mode="insert"/>
    </add>
  </xsl:template>
  
  <xsl:template match="anchor[//zone[@corresp=concat('#', current()/@xml:id)]]">
    <xsl:for-each select="//zone[@corresp=concat('#', current()/@xml:id)]">
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>
  
  <!-- insert mode doesn't copy the element being inserted, but all its contents -->
  <xsl:template match="*" mode="insert">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="addSpan" mode="insert">
    <!-- The anchor $upTo is expected to share its parent with the addSpan:
         this is a problem to come back to! -->
    <xsl:variable name="upTo" select="id(replace(@spanTo,'^#',''))"/>
    <xsl:apply-templates select="following-sibling::node()[. &lt;&lt; $upTo]"/>
  </xsl:template>
  
  
  
</xsl:stylesheet>