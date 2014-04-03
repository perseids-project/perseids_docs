//Currently raises warning when run from the command line, but still works

import java.io._
import scala.io.Source
import scala.xml._
import scala.collection.immutable.ListMap

object alphDir2persFile {


def main(args:Array[String]) = {

	val arguments:List[String] = List(args:_*)

	if (!Set("numFi2Perseids","uriFi2Perseids").contains(arguments(0))) {
		println("Usage: scala alphDir2PersFile.scala <function> <directory_to_merge>")
		System.exit(0)
	}

	arguments(0) match {
		case "numFi2Perseids" => numFi2Perseids(arguments(1))
		case "uriFi2Perseids"=> uriFi2Perseids(arguments(1))
		 }

}



	//case filenames are whole numbers:

def numFi2Perseids (directory: String): Any = {

	def numFiToPerseidsSentAlignXML (filePath:java.io.File): scala.xml.Elem = {
		val sentenceNumber = filePath.getName.replaceAll(".xml","")
		val newSentenceString = scala.io.Source.fromFile(filePath).mkString.replaceAll("1-",sentenceNumber +"-").replaceAll("<sentence>","<sentence id=\""+sentenceNumber+"\" document_id=\"\">").replaceAll("""<wds lnum="L1">""","""<wds lnum="L1">
     |       <comment class="uri"> INSERT URI HERE </comment>""").replaceAll("""<wds lnum="L2">""","""<wds lnum="L2">
     |       <comment class="uri"> INSERT URI HERE </comment>""").replaceAll("xmlns=\"http://alpheios.net/namespaces/aligned-text\"","").replaceAll("xml:lang","lang")
		scala.xml.XML.loadString(newSentenceString)	
}

	
	val sentences = new java.io.File(directory).listFiles.filter(_.getName.endsWith(".xml")).toList.map(x=>(numFiToPerseidsSentAlignXML(x) \\ "sentence").mkString).mkString

	val head = new java.io.File(directory).listFiles.filter(_.getName.endsWith(".xml")).toList.head

	val langList = (numFiToPerseidsSentAlignXML(head) \\ "language").map(_ \ "@lang").toList.map(x=>x.mkString)

	val wrt = new PrintWriter(new File("compositeAlignment.xml"))

	wrt.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
	wrt.println("<aligned-text xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://alpheios.net/namespaces/aligned-text\" xsi:schemaLocation=\"http://alpheios.net/namespaces/aligned-text ../../../../../workspace/schemas/trunk/aligned-text.xsd\">")
	
	//Printing language codes--defaults as left to right
	
	langList.foreach(x => wrt.println("<language lnum=\"L" + (langList.indexOf(x) + 1) + "\" xml:lang=\"" + x + "\" dir=\"ltr\"/>"))
	wrt.println("<comment class=\"title\"> INSERT TITLE OF WORK OR EXTRACT HERE </comment>")
	wrt.print(sentences)
	wrt.flush
	wrt.close

}



//case filenames AREN'T whole numbers but uris 

def uriFi2Perseids (directory: String): Any = {

	def uriFiToPerseidsSentAlignXML (filePath:java.io.File): scala.xml.Elem = {
		
		//1. beginning of file name is currently hard-coded for Thucydides work

		val sentenceNumber = filePath.toString.replaceAll(directory + "/1.","").replaceAll(".xml","").replaceAll("\\.","")
		val uri = filePath.getName.replaceAll(".xml","")
		val newSentenceString = scala.io.Source.fromFile(filePath).mkString.replaceAll("1-",sentenceNumber +"-").replaceAll("<sentence>","<sentence id=\""+sentenceNumber+"\" document_id=\"\">").replaceAll("""<wds lnum="L1">""","""<wds lnum="L1">
     |       <comment class="uri">""" + uri + "</comment>").replaceAll("""<wds lnum="L2">""","""<wds lnum="L2">
     |       <comment class="uri"/>""").replaceAll("xmlns=\"http://alpheios.net/namespaces/aligned-text\"","").replaceAll("xml:lang","lang")
		scala.xml.XML.loadString(newSentenceString)	

}

	//1. beginning of file name is currently hard-coded for Thucydides work

	val numList = new java.io.File(directory).listFiles.filter(_.getName.endsWith(".xml")).toList.map(x=>x.toString.replaceAll(directory + "/1.","").replaceAll(".xml","").replaceAll("\\.","")).map(x=>x.toInt)
	
	val fileList = new java.io.File(directory).listFiles.filter(_.getName.endsWith(".xml")).toList

	val sentences = ListMap((numList.zip(fileList).toMap).toSeq.sortBy(_._1):_*).values.toList.map(x=>(uriFiToPerseidsSentAlignXML(x) \\ "sentence").mkString).mkString

	val head = fileList.head

	val langList = (uriFiToPerseidsSentAlignXML(head) \\ "language").map(_ \ "@lang").toList.map(x=>x.mkString)

	val wrt = new PrintWriter(new File("compositeAlignment.xml"))

	wrt.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
	wrt.println("<aligned-text xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://alpheios.net/namespaces/aligned-text\" xsi:schemaLocation=\"http://alpheios.net/namespaces/aligned-text ../../../../../workspace/schemas/trunk/aligned-text.xsd\">")
	
	//Printing language codes--defaults as left to right
	
	langList.foreach(x => wrt.println("<language lnum=\"L" + (langList.indexOf(x) + 1) + "\" xml:lang=\"" + x + "\" dir=\"ltr\"/>"))
	wrt.println("<comment class=\"title\"> INSERT TITLE OF WORK OR EXTRACT HERE </comment>")
	wrt.print(sentences)
	wrt.println("</aligned-text>")
	wrt.flush
	wrt.close

}
}