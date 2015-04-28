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
        <xsl:variable name="m" select="$here/preceding-sibling::milestone[1]/@spanTo/substring-after(.,'#')"/>
        <xsl:choose>
            <xsl:when test="$here/following-sibling::anchor[1][@xml:id=$m]">
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
            <xsl:call-template name="groupMilestones">
                <xsl:with-param name="set" select="node()"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="groupMilestones">
        <xsl:param name="set"/>
        <xsl:variable name="pass">
            <xsl:for-each-group select="$set"
                group-adjacent="sga:mil(current())">
                <xsl:choose>                    
                    <xsl:when test="current-grouping-key() != ''">
                        <xsl:element name="{current-group()[1]/preceding-sibling::milestone[1]
                                            /@unit/substring-after(.,':')}">
                            <xsl:call-template name="copy_down">
                                <xsl:with-param name="set" select="current-group()"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="current-group()[last()][local-name()='milestone'] and
                                current-group()[1][local-name()='anchor']">
                                <xsl:call-template name="copy_down">
                                    <xsl:with-param name="set" 
                                                    select="remove(remove(current-group(), count(current-group())),1)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="current-group()[last()][local-name()='milestone']">
                                <xsl:call-template name="copy_down">
                                    <xsl:with-param name="set" 
                                        select="remove(current-group(), count(current-group()))"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="current-group()[1][local-name()='anchor']">
                                <xsl:call-template name="copy_down">
                                    <xsl:with-param name="set" select="remove(current-group(), 1)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="copy_down">
                                    <xsl:with-param name="set" select="current-group()"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$pass//milestone">
                <xsl:call-template name="groupMilestones">
                    <xsl:with-param name="set" select="$pass/node()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$pass"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="copy_down">
        <!-- When there are dscendant milestones, we need to recurse down before recursing sideways -->
        <xsl:param name="set"/>
        <xsl:for-each select="$set">
            <xsl:choose>
                <xsl:when test="descendant::milestone">
                    <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:call-template name="groupMilestones">
                            <xsl:with-param name="set" select="node()"/>
                        </xsl:call-template>
                    </xsl:copy>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>