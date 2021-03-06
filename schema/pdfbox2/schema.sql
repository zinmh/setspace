/*
 *  Synopsis:
 *	Schema of the pdfbox.apache.org version 2 api
 *  See:
 *	https://pdfbox.apache.org
 *	http://semver.org/	
 */

\set ON_ERROR_STOP on

BEGIN;

DROP SCHEMA IF EXISTS pdfbox2 CASCADE;
CREATE SCHEMA pdfbox2;
COMMENT ON SCHEMA pdfbox2 IS
  'Text and metadata extracted by pdfbox.apache.org, version 2'
;

/*
 *  Pending pddocument jobs.
 *
 *  Note:
 *	Notice no fk reference to setspace.service(blob).
 *	Sudden termination may leave stale entries.
 */
DROP TABLE IF EXISTS pdfbox2.pddocument_pending CASCADE;
CREATE TABLE pdfbox2.pddocument_pending
(
	blob		udig
				PRIMARY KEY,
	insert_time	timestamptz
				DEFAULT now()
				NOT NULL
);
COMMENT ON TABLE pdfbox2.pddocument_pending IS
  'Pending putPDDocument java processes'
;

/*
 *  PDDocument scalar fields from Java Object
 */
DROP TABLE IF EXISTS pdfbox2.pddocument CASCADE;
CREATE TABLE pdfbox2.pddocument
(
	blob		udig
				REFERENCES setspace.service(blob)
				ON DELETE CASCADE
				PRIMARY KEY,

	exit_status	smallint check (
				exit_status >= 0
				AND
				exit_status <= 255
			)
			not null,

	/*
	 *  Note:
	 *	Specs says number_of_pages is a signed integer,
	 *	which screws up code needing number_of_pages to be
	 *	> 0.  Instead, consider added a exit_status to indicate when
	 *	number_of_pages is <= 0 and set number_of_pages to null.
	 */
	number_of_pages int CHECK (
				/*
				 *  Can a PDF have 0 pages?
				 */
				number_of_pages >= 0
			),

	document_id	bigint,		-- is document_id always > 0

	version		float check (
				version > 0
			),

	--  Record any unexpected stderr produced by blob.
	--  Helpful for debugging the many quirks in pdfbox2.

	stderr_blob	udig,

	is_all_security_to_be_removed	bool,
	is_encrypted			bool,

	--  Track both successful and failed putPDDocument invocations
	--  number_of_pages is not null implies valid pdf;  otherwise
	--  pdf is not loadable.

	CONSTRAINT exec_status CHECK ((

		--  putPDDocument succeeded, all fields null

		exit_status = 0
		AND
		number_of_pages IS NOT NULL
		AND
		version IS NOT NULL	--  do all pdf's have a version?
		AND
		is_all_security_to_be_removed IS NOT NULL
		AND
		is_encrypted IS NOT NULL
	) OR (
		--  putPDDocument failed, all fields null

		exit_status != 0
		AND
		number_of_pages IS NULL
		AND
		version IS NULL	--  do all pdf's have a version?
		AND
		document_id IS NULL
		AND
		is_all_security_to_be_removed IS NULL
		AND
		is_encrypted IS NULL
	))
);
COMMENT ON TABLE pdfbox2.pddocument IS
  'PDDocument scalar fields from Java Object'
;


/*
 *  Status of extraction process for utf8 text.
 */
DROP TABLE IF EXISTS pdfbox2.extract_pages_utf8 CASCADE;
CREATE TABLE pdfbox2.extract_pages_utf8
(
	blob		udig
				REFERENCES pdfbox2.pddocument(blob)
				ON DELETE CASCADE
				PRIMARY KEY,

	exit_status	smallint CHECK (
				exit_status >= 0
				AND
				exit_status <= 255
			),

	stderr_blob	udig,

	--  no quines
	CONSTRAINT stderr_not_blob CHECK (
		blob != stderr_blob
	)
);
COMMENT ON TABLE pdfbox2.extract_pages_utf8 IS
  'Status of extraction process for utf8 text'
;

/*
 *  Track individual pages in a pdf blob
 */
DROP TABLE IF EXISTS pdfbox2.extract_page_utf8 CASCADE;
CREATE TABLE pdfbox2.extract_page_utf8
(
	pdf_blob	udig
				REFERENCES pdfbox2.extract_pages_utf8(blob)
				ON DELETE CASCADE,
	page_blob	udig
				NOT NULL,

	page_number	int check (
				page_number > 0
				AND

				-- Note: why 2603538?  see
				-- http://tex.stackexchange.com/questions/97071

				page_number <= 2603538
			) NOT NULL,

	PRIMARY KEY	(pdf_blob, page_number)

);
COMMENT ON TABLE pdfbox2.extract_pages_utf8 IS
  'Individual Pages of UTF8 Text extracted from parent pdf blob'
;
CREATE INDEX extract_page_utf8_page on pdfbox2.extract_page_utf8(
	page_blob
);

/*
 *  Pending extract_pages_utf8 jobs.
 *
 *  Note:
 *	Notice no fk reference to setspace.service(blob).
 *	Sudden termination may leave stale entries.
 */
DROP TABLE IF EXISTS pdfbox2.extract_pages_utf8_pending CASCADE;
CREATE TABLE pdfbox2.extract_pages_utf8_pending
(
	blob		udig
				PRIMARY KEY,
	insert_time	timestamptz
				DEFAULT now()
				NOT NULL
);
COMMENT ON TABLE pdfbox2.extract_pages_utf8_pending IS
  'Actively running extract_pages_utf8 java processes'
;

/*
 *  Pending pddocument_information jobs.
 *
 *  Note:
 *	Notice no fk reference to setspace.service(blob).
 *	Sudden termination may leave stale entries.
 */
DROP TABLE IF EXISTS pdfbox2.pddocument_information_pending CASCADE;
CREATE TABLE pdfbox2.pddocument_information_pending
(
	blob		udig
				PRIMARY KEY,
	insert_time	timestamptz
				DEFAULT now()
				NOT NULL
);
COMMENT ON TABLE pdfbox2.pddocument_information_pending IS
  'Pending putPDDocumentInformation java processes'
;

/*
 *  PDDocumentInformation scalar fields from Java Object
 */

DROP TABLE IF EXISTS pdfbox2.pddocument_information CASCADE;
CREATE TABLE pdfbox2.pddocument_information
(
	blob			udig
					REFERENCES setspace.service(blob)
					ON DELETE CASCADE
					PRIMARY KEY,
	exit_status		smallint check (
					exit_status >= 0
					AND
					exit_status <= 255
				)
				NOT NULL,

	title			text check (
					length(title) < 32768
				),
	author			text check (
					length(author) < 32768
				),
	creation_date		timestamptz,
	creator			text check (
					length(creator) < 32768
				),

	keywords		text check (
					length(keywords) < 32768
				),
	modification_date	timestamptz,
	producer		text check (
					length(producer) < 32768
				),
	subject			text check (
					length(subject) < 32768
				),
	trapped			text check (
					length(trapped) < 32768
				)
);
COMMENT ON TABLE pdfbox2.pddocument_information IS
  'PDDocumentInformation scalar fields from Java Object'
;

/*
 *  Pending pddocument_information_metadata jobs.
 *
 *  Note:
 *	Notice no fk reference to setspace.service(blob).
 *	Sudden termination may leave stale entries.
 */
DROP TABLE IF EXISTS pdfbox2.pddocument_information_metadata_pending CASCADE;
CREATE TABLE pdfbox2.pddocument_information_metadata_pending
(
	blob		udig
				PRIMARY KEY,
	insert_time	timestamptz
				DEFAULT now()
				NOT NULL
);
COMMENT ON TABLE pdfbox2.pddocument_information_metadata_pending IS
  'Pending putPDDocumentInformation metadata java processes'
;

/*
 *  Job status of extraction process for of Pddocument Information Metadata.
 */
DROP TABLE IF EXISTS pdfbox2.pddocument_information_metadata CASCADE;
CREATE TABLE pdfbox2.pddocument_information_metadata
(
	blob			udig
					REFERENCES setspace.service(blob)
					ON DELETE CASCADE
					PRIMARY KEY,
	exit_status		smallint check (
					exit_status >= 0
					AND
					exit_status <= 255
				)
);
COMMENT ON TABLE pdfbox2.pddocument_information_metadata IS
  'PDDocumentInformation metadata extraction job status'
;

/*
 *  PDDocumentInformation custom metadata fields string fields from Java Object
 */
DROP TABLE IF EXISTS pdfbox2.pddocument_information_metadata_custom CASCADE;
CREATE TABLE pdfbox2.pddocument_information_metadata_custom
(
	blob		udig
				REFERENCES
				   pdfbox2.pddocument_information_metadata(blob)
				ON DELETE CASCADE,
	key		text check (
				length(key) > 0
				AND
				length(key) < 256
				AND
				position(': ' in key) < 1
				AND
				position(E'\n' in key) < 1
			),
	value		text check (
				position(E'\n' in value) < 1
				AND
				length(value) < 32768
			) not null,

	PRIMARY KEY	(blob, key)
);

/*
 *  Text of individual pages of a pdf blob
 */
DROP TABLE IF EXISTS pdfbox2.page_text_utf8 CASCADE;
CREATE TABLE pdfbox2.page_text_utf8
(
	pdf_blob	udig,
	page_number	int check (
				page_number > 0
				AND

				-- Note: why 2603538?  see
				-- http://tex.stackexchange.com/questions/97071

				page_number <= 2603538
			) NOT NULL,
	txt		text
				NOT NULL,
	PRIMARY KEY	(pdf_blob, page_number),
	FOREIGN KEY	(pdf_blob, page_number)
				REFERENCES pdfbox2.extract_page_utf8(
					pdf_blob,
					page_number
				)
				ON DELETE CASCADE
);
COMMENT ON TABLE pdfbox2.page_text_utf8 IS
  'Individual Pages of UTF8 Text extracted from a pdf blob'
;

DROP TABLE IF EXISTS pdfbox2.merge_pages_text_utf8 CASCADE;
CREATE TABLE pdfbox2.merge_pages_text_utf8
(
	blob		udig
				REFERENCES pdfbox2.pddocument(blob)
				ON DELETE CASCADE
				PRIMARY KEY,
	stderr_blob	udig,
	exit_status	smallint check (
				exit_status >= 0
				AND
				exit_status <= 255
			) not null
);

COMMENT ON TABLE pdfbox2.merge_pages_text_utf8 IS
  'Exit Status of merge-pages_text_utf8 script'
;

DROP TABLE IF EXISTS pdfbox2.merge_pages_text_utf8_pending cascade;
CREATE TABLE pdfbox2.merge_pages_text_utf8_pending
(
	blob		udig
				PRIMARY KEY,
	insert_time	timestamptz
				DEFAULT now()
				NOT NULL
);
COMMENT ON TABLE pdfbox2.merge_pages_text_utf8_pending IS
  'Pending merge-pages_text_utf8 jobs'
;

/*
 *  Text Search Vector of individual pages of a pdf blob
 */
DROP TABLE IF EXISTS pdfbox2.page_tsv_utf8 CASCADE;
CREATE TABLE pdfbox2.page_tsv_utf8
(
	pdf_blob	udig,
	page_number	int check (
				page_number > 0
				AND

				-- Note: why 2603538?  see
				-- http://tex.stackexchange.com/questions/97071

				page_number <= 2603538
			) NOT NULL,
	ts_conf		text check (
				--  verify the text ts_conf value is indeed
				--  is a true regconfig.  really ugly.
				--
				--  Note:
				--	Why does
				--	   select ts_conf::regconfig::text
				--	not return the schema qualified name?
				--
				ts_conf = ts_conf::regconfig::text
			),
	tsv		tsvector
				NOT NULL,
	PRIMARY KEY	(pdf_blob, page_number),
	FOREIGN KEY	(pdf_blob, page_number)
				REFERENCES pdfbox2.extract_page_utf8(
					pdf_blob,
					page_number
				)
				ON DELETE CASCADE
);
CREATE INDEX rumidx ON pdfbox2.page_tsv_utf8
  USING
  	rum (tsv rum_tsvector_ops)
;
COMMENT ON TABLE pdfbox2.page_tsv_utf8 IS
  'Individual Pages of UTF8 Text extracted from a pdf blob'
;

DROP TABLE IF EXISTS pdfbox2.merge_pages_tsv_utf8 cascade;
CREATE TABLE pdfbox2.merge_pages_tsv_utf8
(
	blob		udig
				REFERENCES pdfbox2.pddocument(blob)
				ON DELETE CASCADE
				PRIMARY KEY,
	/*
	 *  Note:
	 *	stderr_blob currently ignored.
	 *	eventually hoq will flow stdout/stderr of executed process,
	 *	instead of just flowing the exit_status.
	 */

	stderr_blob	udig,
	exit_status	smallint check (
				exit_status >= 0
				AND
				exit_status <= 255
			) not null
);
COMMENT ON TABLE pdfbox2.merge_pages_tsv_utf8 IS
  'Exit Status of merge-pages_tsv_utf8 script'
;

DROP TABLE IF EXISTS pdfbox2.merge_pages_tsv_utf8_pending cascade;
CREATE TABLE pdfbox2.merge_pages_tsv_utf8_pending
(
	blob		udig
				PRIMARY KEY,
	insert_time	timestamptz
				DEFAULT now()
				NOT NULL
);
COMMENT ON TABLE pdfbox2.merge_pages_tsv_utf8_pending IS
  'Pending merge-pages_tsv_utf8 jobs'
;

COMMIT;
