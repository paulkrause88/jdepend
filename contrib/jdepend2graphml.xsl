<?xml version="1.0"?>

<!-- 
	Takes the XML output from JDepend and transforms it into the 'graphml' 
	language used by yEd (yed.yworks.com) to generate a project dependency graph. 
	The packages show up as rectangles with the package name. Arrows point to 
	other packages the package depends on. 

	Contributed by Paul Krause, building on the work of David Bock. 
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://graphml.graphdrawing.org/xmlns"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:y="http://www.yworks.com/xml/graphml"
	xmlns:yed="http://www.yworks.com/xml/yed/3"
	xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.0/ygraphml.xsd">
	>

	<xsl:output method="xml" />
	<xsl:template match="JDepend">
		<graphml xmlns="http://graphml.graphdrawing.org/xmlns"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:y="http://www.yworks.com/xml/graphml"
			xmlns:yed="http://www.yworks.com/xml/yed/3"
			xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd">
			<key for="node" id="nodegraphics" yfiles.type="nodegraphics"/>
			<graph id="Packages" edgedefault="directed">
				<xsl:apply-templates select="Packages" />
			</graph>
		</graphml>
	</xsl:template>

	<xsl:template match="Packages">
		<xsl:apply-templates select="Package" mode="node" />
	</xsl:template>

	<xsl:template match="Package" mode="node">
		<xsl:element name="node">
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:element name="data">
				<xsl:attribute name="key">nodegraphics</xsl:attribute>
				<xsl:element name="y:ShapeNode">
					<xsl:element name="y:NodeLabel">
						<xsl:value-of select="@name" />
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:apply-templates select="DependsUpon" />
	</xsl:template>

	<xsl:template match="Package" mode="edge">
		<xsl:element name="edge">
			<xsl:attribute name="source"><xsl:value-of select="../../@name" /></xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="." /></xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="DependsUpon">
		<xsl:apply-templates select="Package" mode="edge" />
	</xsl:template>

</xsl:stylesheet>
