<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs"
  version="2.0">
  
<!-- Wrap single page into standalone TEI P5 -->
 
   <xsl:template match="* | @*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude">
      <teiHeader>
        <fileDesc>
          <titleStmt>
            <title/>
          </titleStmt>
          <publicationStmt>
            <p>For internal use: not for publication.</p>        
          </publicationStmt>
          <sourceDesc>
            <p>Created in support of Shelley-Godwin Archive XSLT.</p>
          </sourceDesc>
        </fileDesc>
      </teiHeader>
      <text>
        <body>
          <div>
            <xsl:apply-templates/>
          </div>
        </body>
      </text>
    </TEI>
  </xsl:template>

</xsl:stylesheet>
