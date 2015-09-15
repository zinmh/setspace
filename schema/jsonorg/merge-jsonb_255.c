/* Processed by ecpg (4.11.0) */
/* These include files are added by the preprocessor */
#include <ecpglib.h>
#include <ecpgerrno.h>
#include <sqlca.h>
/* End of automatic include section */

#line 1 "merge-jsonb_255.pgc"
/*
 *  Synopsis:
 *  	Merge a json blob read on standard input into table json.jsonb_255.
 *  Arguments:
 *  	1	udig of the blob
 *  	2	number of bytes to read on the standard input
 *  Exit Status:
 *  	0	ok, tuple was merged
 *  	1	Wrong number of arguments
 *  	2	incorrect blob size
 *  	3	malloc() of json buffer failed
 *	4	read() of standard input failed
 *	5	syntax error on udig
 *	6	sql error
 *  Blame:
 *  	jmscott@setspace.com
 *  	setspace@gmail.com
 *  Note:
 *	Rewrite insert() as upsert. 
 */

#define EXIT_OK	0
#define EXIT_BADARGC 1
#define EXIT_BADSIZE 2
#define EXIT_BADMALLOC 3
#define EXIT_BADREAD 4
#define EXIT_BADUDIG 5
#define EXIT_SQLERROR 6
#define EXIT_SQLWARN 7

#include <unistd.h>
#include <stdlib.h>

static int
die(int status, char *msg)
{
	static char ERROR[] = "ERROR: ";
	static char nl[] = "\n";

	write(2, ERROR, sizeof ERROR - 1);
	write(2, msg, strlen(msg));
	write(2, nl, sizeof nl - 1);

	_exit(status);
}

//  fast, safe, simple, rational string concatenator

static void
_strcat(char *tgt, int tgtsize, char *src)
{
	//  find null terminated end of target buffer
	while (*tgt++)
		--tgtsize;
	--tgt;

	//  copy non-null src bytes while at least one byte in target
	while (--tgtsize > 0 && *src)
		*tgt++ = *src++;

	// target always null terminated
	*tgt = 0;
}

static void
die2(int status, char *msg1, char *msg2)
{
	static char colon[] = ": ";
	char msg[256];

	msg[0] = 0;
	_strcat(msg, sizeof msg, msg1);
	_strcat(msg, sizeof msg, colon);
	_strcat(msg, sizeof msg, msg2);

	die(status, msg);
}

static void
sql_fault()
{
	char msg[1024];
	char state[6];
	int status = EXIT_SQLERROR;

	if (sqlca.sqlcode == 0)
		die(EXIT_SQLERROR, "unexpected sqlca.sqlcode == 0"); 
	_strcat(msg, sizeof msg, "sql");

	//  what is a WARNING ... pg9.4docs not too clear

	if (sqlca.sqlwarn[2] == 'W' || sqlca.sqlwarn[0] == 'W') {
		_strcat(msg, sizeof msg, ": WARN");
		status = EXIT_SQLWARN;
	}

	//  add the sql state code to error message

	if (sqlca.sqlstate[0] != 0) {
		char state[6];

		_strcat(msg, sizeof msg, ": ");
		memmove(state, sqlca.sqlstate, 5);
		state[5] = 0;
		_strcat(msg, sizeof msg, state);
	}

	//  add the sql error message

	if (sqlca.sqlerrm.sqlerrml > 0) {
		char err[SQLERRMC_LEN + 1];

		_strcat(msg, sizeof msg, ": ");
		memmove(err, sqlca.sqlerrm.sqlerrmc, sqlca.sqlerrm.sqlerrml);
		err[sqlca.sqlerrm.sqlerrml] = 0;
		_strcat(msg, sizeof msg, err);
	}
	die(status, msg);
}


int
main(int argc, char **argv)
{
	int size, nread = 0, nr;
	size_t len;
	char *sz;

/* exec sql begin declare section */
	 
	 

#line 130 "merge-jsonb_255.pgc"
 char * blob ;
 
#line 131 "merge-jsonb_255.pgc"
 char * doc ;
/* exec sql end declare section */
#line 132 "merge-jsonb_255.pgc"


	if (argc != 3)
		die(EXIT_BADARGC, "wrong number of arguments, expected 3");

	//  parse the udig as argv[1]
	blob = argv[1];
	len = strlen(blob);
	if (len < 3 || len > 255 || strchr(blob, ':') == NULL)
		die2(EXIT_BADUDIG, "syntax error in json udig", blob);

	//  parse the blob size as argv[2]
	sz = argv[2];
	len = strlen(sz);
	if (len < 1 || len > 19)
		die2(EXIT_BADSIZE, "blob size not > 0 and < 20 chars", sz);

	//  need to validate that all chars are decimal digits
	size = atoi(sz);
	if (size <= 0)
		die2(EXIT_BADSIZE, "atoi(blob size) <= 0", sz);

	//  allocate the json buffer plus null byte
	doc = malloc(size + 1);
	if (doc == NULL)
		die2(EXIT_BADMALLOC, "malloc() failed", sz);
	doc[size] = 0;

	//  read the json blob from standard input
	nread = 0;
again:
	nr = read(0, doc + nread, size - nread);
	if (nr < 0) {
		if (errno == EINTR)
			goto again;
		die2(EXIT_BADREAD, "read() failed", strerror(errno));
	}
	if (nr > 0) {
		nread += nr;
		if (nread < size)
			goto again;
	}

	/* exec sql whenever sqlerror  call sql_fault ( ) ; */
#line 175 "merge-jsonb_255.pgc"

	/* exec sql whenever sql_warning  call sql_fault ( ) ; */
#line 176 "merge-jsonb_255.pgc"

	{ ECPGconnect(__LINE__, 0, NULL, NULL, NULL, "DEFAULT", 0); 
#line 177 "merge-jsonb_255.pgc"

if (sqlca.sqlwarn[0] == 'W') sql_fault ( );
#line 177 "merge-jsonb_255.pgc"

if (sqlca.sqlcode < 0) sql_fault ( );}
#line 177 "merge-jsonb_255.pgc"


	/*
	 *  Merge blob into json table.
	 */

	{ ECPGtrans(__LINE__, NULL, "begin transaction");
#line 183 "merge-jsonb_255.pgc"

if (sqlca.sqlwarn[0] == 'W') sql_fault ( );
#line 183 "merge-jsonb_255.pgc"

if (sqlca.sqlcode < 0) sql_fault ( );}
#line 183 "merge-jsonb_255.pgc"


	{ ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "lock table json . jsonb_255 in share row exclusive mode", ECPGt_EOIT, ECPGt_EORT);
#line 185 "merge-jsonb_255.pgc"

if (sqlca.sqlwarn[0] == 'W') sql_fault ( );
#line 185 "merge-jsonb_255.pgc"

if (sqlca.sqlcode < 0) sql_fault ( );}
#line 185 "merge-jsonb_255.pgc"

	{ ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "insert into json . jsonb_255 ( blob , doc ) select $1  :: udig , $2  :: jsonb where not exists ( select blob from json . jsonb_255 where blob = $3  :: udig )", 
	ECPGt_char,&(blob),(long)0,(long)1,(1)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,&(doc),(long)0,(long)1,(1)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,&(blob),(long)0,(long)1,(1)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);
#line 202 "merge-jsonb_255.pgc"

if (sqlca.sqlwarn[0] == 'W') sql_fault ( );
#line 202 "merge-jsonb_255.pgc"

if (sqlca.sqlcode < 0) sql_fault ( );}
#line 202 "merge-jsonb_255.pgc"


	{ ECPGtrans(__LINE__, NULL, "end transaction");
#line 204 "merge-jsonb_255.pgc"

if (sqlca.sqlwarn[0] == 'W') sql_fault ( );
#line 204 "merge-jsonb_255.pgc"

if (sqlca.sqlcode < 0) sql_fault ( );}
#line 204 "merge-jsonb_255.pgc"


	_exit(EXIT_OK);
}
