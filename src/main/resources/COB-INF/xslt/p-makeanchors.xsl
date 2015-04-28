<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Supply tei:p mileston/anchor pairs when missing -->   
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div[@type='chapter'] | ab[@type='surface']">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <!-- Only group around top-level milestones; line-level milestones should be left alone -->
            <xsl:for-each-group select="node()" group-starting-with="milestone">
                <xsl:choose>
                    <xsl:when test="current-group()/self::milestone[@spanTo]">
                        <xsl:choose>
                            <xsl:when test="current-group()/self::anchor">
                                <xsl:for-each-group select="current-group()" group-ending-with="anchor">
                                    <xsl:choose>
                                        <xsl:when test="current-group()/self::anchor">
                                            <xsl:apply-templates select="current-group()"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- This catches orfan nodes after an anchor. Wrap them in a p -->
                                            <xsl:variable name="anchor_id" select="generate-id()"/>
                                            <milestone unit="tei:p" spanTo="{concat('#', $anchor_id)}"/>    
                                            <xsl:apply-templates select="current-group()"/>
                                            <anchor xml:id="{$anchor_id}"/>                              
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each-group>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="anchor_id" select="generate-id()"/>
                        <milestone unit="tei:p" spanTo="{concat('#', $anchor_id)}"/>    
                        <xsl:apply-templates select="current-group()"/>
                        <anchor xml:id="{$anchor_id}"/>
                    </xsl:otherwise>
                </xsl:choose>                  
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="milestone[@unit='tei:p']"/>
    
</xsl:stylesheet>