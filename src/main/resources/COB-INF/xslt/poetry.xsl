<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">
    
    <!-- Deal with poetic text, expanding verse lines if necessary -->
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="lg">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="*">
                <xsl:choose>
                    <xsl:when test="self::l">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:when test="self::line">
                        <l><xsl:copy-of select="node()"/></l>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>