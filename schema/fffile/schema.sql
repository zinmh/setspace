/*
 *  Synopsis:
 *	Schema for the file type guesser "Find Free File Command", version 5
 *  See:
 *	http://www.darwinsys.com/file/
 */

\set ON_ERROR_STOP on

BEGIN;

DROP SCHEMA IF EXISTS fffile CASCADE;
CREATE SCHEMA fffile;
COMMENT ON SCHEMA fffile IS
  'Text and metadata extracted by "Find Free File Command", version 5'
;

/*
 *  Output of 'file --brief' command on blob.
 */
DROP TABLE IF EXISTS fffile.file CASCADE;
CREATE TABLE fffile.file
(
	blob		udig
				primary key,
	file_type	text
);
COMMENT ON TABLE fffile.file IS
  'Output of file --brief command on blob'
;

/*
 *  Output of 'file --mime-type --brief' command on blob.
 */
DROP TABLE IF EXISTS fffile.file_mime_type CASCADE;
CREATE TABLE fffile.file_mime_type
(
	blob		udig
				primary key,
	mime_type	text
);
COMMENT ON TABLE fffile.file_mime_type IS
  'Output of file --mime-type --brief command on blob'
;

/*
 *  Output of 'file --mime-encoding --brief' command on blob.
 */
DROP TABLE IF EXISTS fffile.file_mime_encoding CASCADE;
CREATE TABLE fffile.file_mime_encoding
(
	blob		udig
				primary key,
	mime_encoding	text
);
COMMENT ON TABLE fffile.file_mime_encoding IS
  'Output of file --mime-encoding --brief command on blob'
;

COMMIT;