# readingTEI

This is a Cocoon 2.2 block to convert [Shelley-Godwine Archive](http://www.tei-c.org/SIG/Music/) TEI files from documentary encoding to TEI Lite.

It's a wrapper for the XSLTs already published by Wendell Piez [here](https://github.com/wendellpiez/MITH_XSLT), with a few minor adjustments.

# Compiling the block and webapp

To compile the block so that it can be used in a webapp, run:

`$ mvn install`

Then step out of the directory to create a Cocoon 2.2. webapp:

`mvn archetype:generate -DarchetypeCatalog=http://cocoon.apache.org`

Pick option 3, then set the values for the Maven package (more info [here](http://cocoon.apache.org/2.2/1362_1_1.html)).

In the pom.xml setting file, load the block as dependency:

`<dependency>
	<groupId>org.mith</groupId>
	<artifactId>readingTEI</artifactId>
	<version>1.0.0</version>
</dependency>`

Then create the war package and you should be good to go:

`mvn package`

Deploy the war file to Tomcat or test it with jetty using

`mvn jetty:run`