
-------PURPOSE--------

Very hasty application written to convert a folder of raw Alpheios translation alignment output, named as numbered XML files, to a single file in Perseids structure. 

Outputs a single file named "compositealignment.xml" in the same folder as alphDir2persFile.scala, despite raising a warning. 

-------USAGE----------

In OSX Terminal,

>>for files named X.xml where X is a series of integers:

scala alphDir2persFile "numFi2Perseids" "NAME_OF_DIRECTORY"

e.g. scala alphDir2persFile "numFi2Perseids" "numTest"

>> for files named 1.XXX.XX where X is as long a sequence of integers as desired and represents the URI for the sentence file:

scala alphDir2persFile "uriFi2Perseids"	"NAME_OF_DIRECTORY"

e.g. scala alphDir2persFile "uriFi2Perseids" "uriTest"

-------CURRENT HARDCODING--------

-File names for "uriFi2Perseids" are currently hard-coded for Thucydides work.

-Language @dir defaults to 'ltr'.

-URIs in "numFi2Perseids" and title comments in both functions need to be inserted manually. 

-------TO-DO-------

-Make more flexible and fix the hardcoding.

-Accept user input for document_id and name of output file.

-Fix internal redundancy and sloppiness

-Package as .jar

-Debug the warning raised in the command line.

