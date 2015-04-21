<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sga="http://shelleygodwinarchive.org/ns/1.0"
    exclude-result-prefixes="#all">
    
    <!-- Recursive milestone promotion. Must have @spanTo and an anchor -->
    
    <xsl:function name="sga:mil">
        <xsl:param name="here"/>
        <xsl:variable name="m" select="$here/preceding::milestone[1]/@spanTo/substring-after(.,'#')"/>
        <xsl:choose>
            <xsl:when test="$here/following::anchor[1][@xml:id=$m]">
                <xsl:value-of select="$m"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="div[@type='chapter'] | ab[@type='surface']">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:variable name="one"><xsl:call-template name="groupMilestones">
                <xsl:with-param name="set" select="node()"/>
            </xsl:call-template></xsl:variable>
            <xsl:sequence select="$one"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="groupMilestones">
        <xsl:param name="set"/>
        <xsl:variable name="pass">
            <xsl:for-each-group select="$set"
                group-adjacent="sga:mil(current())">
                <xsl:choose>
                    <xsl:when test="current-grouping-key() != ''">
                        <xsl:element name="{current-group()[1]/preceding::milestone[1]/@unit/substring-after(.,':')}">
                            <xsl:copy-of select="current-group()"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="current-group()[last()][local-name()='milestone'] and
                                current-group()[1][local-name()='anchor']">
                                <xsl:copy-of select="remove(remove(current-group(), count(current-group())),1)"/>
                            </xsl:when>
                            <xsl:when test="current-group()[last()][local-name()='milestone']">
                                <xsl:copy-of select="remove(current-group(), count(current-group()))"/>
                            </xsl:when>
                            <xsl:when test="current-group()[1][local-name()='anchor']">
                                <xsl:copy-of select="remove(current-group(), 1)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$pass//milestone">
                <xsl:message>pass</xsl:message>
                <xsl:call-template name="groupMilestones">
                    <xsl:with-param name="set" select="$pass/node()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$pass"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>