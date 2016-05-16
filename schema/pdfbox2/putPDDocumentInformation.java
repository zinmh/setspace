/*
 *  Synopsis:
 *	Put the PDDocumentInformation scalar data onto standard output.
 *  Description:
 *	putPDDocumentInformation extracts PDDocument metadata from a pdf
 *	document read on standard input and then writes that metadata as a
 *	new-line separated list of mime-header fields.
 *
 *		Author: <author>
 *
 *  Usage:
 *	java putPDDocument <file.pdf
 *  Exit Status:
 *	0	extracted the scalar data and wrote to stdout
 *	1	load of pdf failed
 *	2	wrong number of command line arguments
 *	3	field contained new-line character
 *	4	unexpected java exception.
 */
import java.util.Calendar;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;

public class putPDDocumentInformation
{
	public static void main(String[] args) throws Exception
	{
		if (args.length != 0) {
			System.err.println("ERROR: " +
				putPDDocumentInformation.class.getName() +
				   ": wrong number of arguments");
			System.exit(2);
		}

		PDDocument doc = null;
		PDDocumentInformation info;

		try {
			/*
			 *  Note:
			 *	BufferedInputStream makes no difference in
			 *	speed, according to simple tests on a few
			 *	pdfs.
			 */
			try {
				doc = PDDocument.load(System.in);
			} catch (Exception el) {
				System.err.println("ERROR: " +
				      putPDDocumentInformation.class.getName() +
								": " + el);
				System.exit(1);
			}
			info = doc.getDocumentInformation();

			//  Author: ...

			String s = info.getAuthor();
			if (s != null) {
				if (s.indexOf("\n") > -1)
					System.exit(3);
				System.out.println("Author: " + s);
			}

			//  Subject: ...

			s = info.getSubject();
			if (s != null) {
				if (s.indexOf("\n") > -1)
					System.exit(3);
				System.out.println("Subject: " + s);
			}

			//  Keywords: ...

			s = info.getKeywords();
			if (s != null) {
				if (s.indexOf("\n") > -1)
					System.exit(3);
				System.out.println("Keywords: " + s);
			}

			//  Creator: ...

			s = info.getCreator();
			if (s != null) {
				if (s.indexOf("\n") > -1)
					System.exit(3);
				System.out.println("Creator: " + s);
			}

			//  Producer: ...

			s = info.getProducer();
			if (s != null) {
				if (s.indexOf("\n") > -1)
					System.exit(3);
				System.out.println("Producer: " + s);
			}

			//  Creation Date: ...

			Calendar cal = info.getCreationDate();
			if (cal != null)
				System.out.println("Creation Date: " + cal);

			//  Modification Date: ...

			cal = info.getModificationDate();
			if (cal != null)
				System.out.println("Modification Date: " + cal);

			//  Trapped: ...

			s = info.getTrapped();
			if (s != null)
				System.out.println("Trapped: " + s);

		} catch (Exception e) {
			System.err.println("ERROR: " +
				putPDDocumentInformation.class.getName() +
				   	": " + e);
			System.exit(4);

		} finally {
			if (doc != null)
				doc.close();
		}
		System.exit(0);
	}
}